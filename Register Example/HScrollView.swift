//
//  HScrollView.swift
//  Register Example
//
//  Created by Example on 9/5/20.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

final class HScrollView: UIScrollView {

    fileprivate static let KCheckAndRadioTag = 9000
    fileprivate static let KTextFieldTag = 4000
    
    let titleLabel = UILabel.lableInit(title: "")
    
    var fieldsArray: APIValueElement? = nil
    
    //(ArrayIndex (Key): Int, optionIndex (Value): Int)
    lazy var radioButtonSelectedIndex: [Int: Int] = [:]
    lazy var checkButtonSelectedIndex: [Int: [Int]] = [:]
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(field: APIValueElement?) {
        fieldsArray = field
        
        guard fieldsArray != nil else { return }
        
        removeOldUI()
        createUI()
    }
    
    private func createUI() {
        guard let haveArray = fieldsArray else { return }
        let haveFieldArray = haveArray.fields
        
        titleLabel.text = haveArray.title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        addSubview(titleLabel)
        
        let defaultPadding: CGFloat = 8.0
        var viewDict: [String: UIView] = ["titleLabel": titleLabel, "scrollView": self]
        let metricDict: [String: CGFloat] = ["defaultPadding": defaultPadding]
        var hString = "H:|[titleLabel(scrollView)]"
        var vString = "V:|-defaultPadding-[titleLabel]-defaultPadding-"
        
        for (index, loopValue) in haveFieldArray.enumerated() {
            let currentView: UIView
            let titleString = "\(loopValue.title)\(loopValue.isMandatory ? "*":"")"
            
            switch loopValue.inputType {
            case .check:
                currentView = radioAndCheckView(with: titleString, buttonArray: loopValue.options?.split(separator: ",").map { String($0) }, row: index, isCheckBox: true)
            case .radio:
                currentView = radioAndCheckView(with: titleString, buttonArray: loopValue.options?.split(separator: ",").map { String($0) }, row: index, isCheckBox: false)
            case .number:
                currentView = textFieldView(with: titleString, isNumber: true, row: index)
            default:
                currentView = textFieldView(with: titleString, isNumber: false, row: index)
            }
            
            addSubview(currentView)
            
            let viewName = "currentView\(index+1)"
            viewDict[viewName] = currentView
            
            if index == 0 {
                vString+="[\(viewName)]"
            } else {
                vString+="-defaultPadding-[\(viewName)]"
            }
        }
        
        hString+="|"
        vString+="|"
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: hString,
                                                                   options: [],
                                                                   metrics: metricDict,
                                                                   views: viewDict))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: vString,
                                                                   options: [.alignAllLeading, .alignAllTrailing],
                                                                   metrics: metricDict,
                                                                   views: viewDict))
        
        layoutIfNeeded()
        scrollRectToVisible(CGRect.zero, animated: true)
    }
    
    private func removeOldUI() {
        for loopValue in self.subviews {
            loopValue.removeFromSuperview()
        }
    }
    
    func nextButtonTapped() -> [String: Any] {
        keyboardDone()
        return createResponseDict()
    }
    
    func createResponseDict() -> [String: Any] {
        guard let haveFieldArray = fieldsArray else { return [:] }
        var returnArray: [String: Any] = [:]
        
        for (index, loopValue) in haveFieldArray.fields.enumerated() {
            switch loopValue.inputType {
            case .check:
                if let haveOptionArray = loopValue.options?.split(separator: ",").map({ String($0) }),
                    let isCheckSelected = checkButtonSelectedIndex[index],
                    isCheckSelected.count > 0 {
                    var arrayString = ""
                    var commaString = ""
                    
                    for checkLoopValue in isCheckSelected {
                        if haveOptionArray.count > checkLoopValue {
                            arrayString+="\(commaString)\(haveOptionArray[checkLoopValue])"
                            commaString = ","
                        }
                    }
                    
                    returnArray[loopValue.apiKey] = arrayString
                } else {
                    if loopValue.isMandatory {
                        
                    returnArray.removeAll()
                    returnArray[Strings.InputJSONError.error] = "\(loopValue.title) \(Strings.InputJSONError.checkNotSelected)"
                    return returnArray
                    }
                }
            case .radio:
                if let haveOptionArray = loopValue.options?.split(separator: ",").map({ String($0) }),
                    let isRadioSelected = radioButtonSelectedIndex[index] {
                    returnArray[loopValue.apiKey] = haveOptionArray[isRadioSelected]
                } else {
                    if loopValue.isMandatory {
                        
                    returnArray.removeAll()
                    returnArray[Strings.InputJSONError.error] = "\(loopValue.title) \(Strings.InputJSONError.radioNotSelected)"
                    return returnArray
                    }
                }
            case .text, .number:
                if let haveTextField = viewWithTag(HScrollView.KTextFieldTag+index) as? UITextField,
                    let haveText = haveTextField.text, haveText.count > 0 {
                    returnArray[loopValue.apiKey] = haveText
                } else {
                    if loopValue.isMandatory {
                        
                    returnArray.removeAll()
                    returnArray[Strings.InputJSONError.error] = "\(loopValue.title) \(Strings.InputJSONError.textNotEntered)"
                    return returnArray
                    }
                }
            }
        }
        
        return returnArray
    }
    
}

fileprivate extension HScrollView {
    //Mark: UI Creation
    
    func textFieldView(with title: String, isNumber: Bool, row: Int) -> UIView {
        let bgView = UIView.viewInit()
        let titleLabel = UILabel.lableInit(title: title)
        let textField = UITextField.textFieldInit(placeHolder: title)
        
        titleLabel.adjustsFontSizeToFitWidth = true
        textField.keyboardType = isNumber ? .phonePad:.default
        textField.inputAccessoryView = UIToolbar.doneButton(target: self, action: #selector(keyboardDone))
        textField.delegate = self
        textField.tag = HScrollView.KTextFieldTag+row
        
        bgView.addSubview(titleLabel)
        bgView.addSubview(textField)
        
        let defaultPadding: CGFloat = 8.0
        let textFieldHeight: CGFloat = 45.0
        let constraintArray = [
            titleLabel.topAnchor.constraint(equalTo: bgView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -defaultPadding),
            titleLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: defaultPadding*2),
            titleLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -defaultPadding*2),
            titleLabel.heightAnchor.constraint(equalToConstant: textFieldHeight),
            textField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            textField.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -defaultPadding)
        ]
        
        NSLayoutConstraint.activate(constraintArray)
        
        return bgView
    }
    
    func radioAndCheckView(with title: String, buttonArray: [String]?, row: Int, isCheckBox: Bool) -> UIView {
        let bgView = UIView.viewInit()
        let titleLabel = UILabel.lableInit(title: title)
        let radioBGView = UITextField.viewInit()
        
        titleLabel.adjustsFontSizeToFitWidth = true
        
        bgView.addSubview(titleLabel)
        bgView.addSubview(radioBGView)
        
        let defaultPadding: CGFloat = 8.0
        let imageViewHeight: CGFloat = 45.0
        let constraintArray = [
            titleLabel.topAnchor.constraint(equalTo: bgView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: radioBGView.topAnchor, constant: -defaultPadding),
            titleLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: defaultPadding*2),
            titleLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -defaultPadding*2),
            titleLabel.heightAnchor.constraint(equalToConstant: imageViewHeight),
            radioBGView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            radioBGView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            radioBGView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -defaultPadding)
        ]
        
        NSLayoutConstraint.activate(constraintArray)
        
        if let haveButtonArray = buttonArray, haveButtonArray.count > 0 {
            var viewDict: [String: UIView] = ["radioBGView": radioBGView]
            let metricDict = ["defaultPadding": defaultPadding]
            var hString = "H:|-defaultPadding-"
            var vString = "V:|"
            
            for (index, loopValue) in haveButtonArray.enumerated() {
                let bgControl = UIControl.controlInit()
                let imageView = UIImageView.imageViewInit(imageName: "empty_circle")
                let radioTitle = UILabel.lableInit(title: loopValue)
                
                bgControl.addTarget(self,
                                    action: isCheckBox ? #selector(checkControlAction(_:)):#selector(radioControlAction(_:)),
                                    for: .touchUpInside)
                radioTitle.adjustsFontSizeToFitWidth = true
                bgControl.tag = row*HScrollView.KCheckAndRadioTag+index
                
                bgControl.addSubview(imageView)
                bgControl.addSubview(radioTitle)
                radioBGView.addSubview(bgControl)
                
                let loopConstraintLayout = [
                    imageView.topAnchor.constraint(equalTo: bgControl.topAnchor),
                    imageView.leadingAnchor.constraint(equalTo: bgControl.leadingAnchor, constant: defaultPadding),
                    imageView.heightAnchor.constraint(equalToConstant: imageViewHeight),
                    imageView.widthAnchor.constraint(equalToConstant: imageViewHeight),
                    imageView.bottomAnchor.constraint(equalTo: bgControl.bottomAnchor, constant: -defaultPadding),
                    radioTitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: defaultPadding),
                    radioTitle.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
                    radioTitle.trailingAnchor.constraint(equalTo: bgControl.trailingAnchor, constant: -defaultPadding)
                ]
                
                NSLayoutConstraint.activate(loopConstraintLayout)
                
                let viewName = "bgControl\(index+1)"
                viewDict[viewName] = bgControl
                
                if index == 0 {
                    vString+="[\(viewName)]"
                    hString+="[\(viewName)]"
                } else {
                    vString+="-defaultPadding-[\(viewName)]"
                }
            }
            
            hString+="-defaultPadding-|"
            vString+="|"
            
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: hString,
                                                                       options: [],
                                                                       metrics: metricDict,
                                                                       views: viewDict))
            
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: vString,
                                                                       options: [.alignAllLeading, .alignAllTrailing],
                                                                       metrics: metricDict,
                                                                       views: viewDict))
        }
        
        return bgView
    }
    
}

extension HScrollView {
    //Mark: Button Action
    
    @objc fileprivate func keyboardDone() {
        endEditing(true)
    }
    
    @objc fileprivate func radioControlAction(_ selector: UIControl) {
        let rowIndex = selector.tag/HScrollView.KCheckAndRadioTag
        let radioIndex = selector.tag%HScrollView.KCheckAndRadioTag
        if let currentField = fieldsArray?.fields[rowIndex],
            let arrayValue = currentField.options?.split(separator: ",").map({ String($0) }) {
            for (index, _) in arrayValue.enumerated() {
                if let controlView = viewWithTag(rowIndex*HScrollView.KCheckAndRadioTag+index) as? UIControl,
                    let haveImageView = retriveImageView(from: controlView) {
                    if radioIndex == controlView.tag%HScrollView.KCheckAndRadioTag {
                        haveImageView.image = UIImage(named: "checked_circle")
                        radioButtonSelectedIndex[rowIndex] = radioIndex
                    } else {
                        haveImageView.image = UIImage(named: "empty_circle")
                    }
                }
            }
        }
    }
    
    @objc fileprivate func checkControlAction(_ selector: UIControl) {
        let rowIndex = selector.tag/HScrollView.KCheckAndRadioTag
        let radioIndex = selector.tag%HScrollView.KCheckAndRadioTag
        if let haveImageView = retriveImageView(from: selector) {
            if let haveRow = checkButtonSelectedIndex[rowIndex],
                haveRow.contains(radioIndex),
                let subIndex = haveRow.firstIndex(of: radioIndex) {
                haveImageView.image = UIImage(named: "empty_circle")
                checkButtonSelectedIndex[rowIndex]?.remove(at: subIndex)
            } else {
                haveImageView.image = UIImage(named: "check")
                
                let appendArray: [Int]
                
                if var haveRow = checkButtonSelectedIndex[rowIndex] {
                    haveRow.append(radioIndex)
                    appendArray = haveRow
                } else {
                    appendArray = [radioIndex]
                }
                
                checkButtonSelectedIndex[rowIndex] = appendArray
            }
        }
    }
    
    private func retriveImageView(from control: UIControl) -> UIImageView? {
        for loopValue in control.subviews {
            if loopValue is UIImageView {
                return loopValue as? UIImageView
            }
        }
        return nil
    }
}

extension HScrollView: UITextFieldDelegate {
    //Mark: TextView Delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        contentInset = UIEdgeInsets.zero
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: UIScreen.main.bounds.height/2.0, right: 0)
    }
}
