//
//  ViewController.swift
//  Register Example
//
//  Created by Example on 9/5/20.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var jsonInput: [APIValueElement]? = {
        if let path = Bundle.main.path(forResource: "input_json", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                if let jsonResult = try? JSONDecoder().decode([APIValueElement].self, from: data) {
                    return jsonResult
                  }
              } catch {
                   // handle error
              }
        }
        
        return nil
    }()
    
    let vScrollView = HScrollView()
    
    let titleLabel = UILabel.lableInit(title: Strings.Common.appName)
    
    let nextButton = UIButton.buttonInit(title: Strings.Home.next, bgColor: UIColor.init(red: 33/255, green: 170/255, blue: 71/255, alpha: 1))
    let backButton = UIButton.buttonInit(title: Strings.Home.back, bgColor: UIColor.init(red: 33/255, green: 170/255, blue: 71/255, alpha: 1))
    
    lazy var pageDetailsArray: [APIValueElement] = []
    lazy var responseToAPIDict: [String: Any] = [:]
    
    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        generalSetup()
    }

    //Mark: General Init
    
    func generalSetup() {
        guard jsonInput != nil else {
            showAlert(message: Strings.InputJSONError.invalidJSON)
            return
        }
        
        view.backgroundColor = UIColor.init(red: 0, green: 114/255, blue: 170/255, alpha: 1)
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect.init(x: 0, y: 44.0, width: UIScreen.main.bounds.size.width, height: 1.0)
        bottomLayer.backgroundColor = UIColor.black.cgColor
        titleLabel.layer.addSublayer(bottomLayer)
        
        nextButton.addTarget(self, action: #selector(nextButtonAction(_:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        backButton.isEnabled = false

        vScrollView.setupUI(field: jsonInput![currentPage])
        
        view.addSubview(titleLabel)
        view.addSubview(vScrollView)
        view.addSubview(backButton)
        view.addSubview(nextButton)
        
        uiConstraintsSetup()
    }
    
    func uiConstraintsSetup() {
        let defaultPadding: CGFloat = 8.0
        let buttonHeight: CGFloat = 45.0
        let buttonWidth: CGFloat = view.frame.size.width*0.25
        let constrinatLayout = [
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: buttonHeight/2.0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: buttonHeight),
            vScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            vScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            backButton.heightAnchor.constraint(equalTo: nextButton.heightAnchor),
            backButton.bottomAnchor.constraint(equalTo: nextButton.bottomAnchor),
            backButton.widthAnchor.constraint(equalTo: nextButton.widthAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: defaultPadding),
            backButton.trailingAnchor.constraint(lessThanOrEqualTo: nextButton.leadingAnchor, constant: -defaultPadding),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -defaultPadding),
            nextButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -defaultPadding),
            nextButton.topAnchor.constraint(equalTo: vScrollView.bottomAnchor, constant: defaultPadding),
            nextButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        ]
        NSLayoutConstraint.activate(constrinatLayout)
    }

}

extension ViewController {
    //Mark: Button Action
    
    @objc func nextButtonAction(_ sender: UIButton) {
        let currentPageValue = vScrollView.navigationButtonTapped()
        
        guard let haveSccuessDetails = currentPageValue.response else {
            let haveValue = currentPageValue.error[Strings.InputJSONError.message] as? String
            showAlert(message: (haveValue ?? Strings.Alert.somethingWentWrong))
            return
        }
        
        updateUserDetailsArray(with: haveSccuessDetails)
        
        if let haveJsonInput = jsonInput {
            if currentPage >= (haveJsonInput.count-1) {
                print(createResponseDict())
                showAlert(message: Strings.Home.successRegistration)
            } else {
                backButton.isEnabled = true
                
                let fiedlValue: APIValueElement
                
                if currentPage+1 < pageDetailsArray.count {
                    fiedlValue = pageDetailsArray[currentPage+1]
                } else {
                    fiedlValue = haveJsonInput[currentPage+1]
                }
                
                currentPage+=1
                vScrollView.setupUI(field: fiedlValue)
                
                if currentPage >= (haveJsonInput.count-1) {
                    nextButton.setTitle(Strings.Home.submit, for: .normal)
                }
            }
        }
    }
    
    private func updateUserDetailsArray(with sccuessDetails: APIValueElement) {
        if currentPage == pageDetailsArray.count {
            pageDetailsArray.append(sccuessDetails)
        } else {
            pageDetailsArray[currentPage] = sccuessDetails
        }
    }
    
    private func createResponseDict() -> [String: Any] {
        var returnArray: [String: Any] = [:]
        
        for loopArray in pageDetailsArray {
            for loopValue in loopArray.fields {
                if let haveUserInput = loopValue.userInput {
                    returnArray[loopValue.apiKey] = haveUserInput
                }
            }
        }
        
        return returnArray
    }
    
    @objc func backButtonAction(_ sender: UIButton) {
        let currentPageValue = vScrollView.navigationButtonTapped(needAlert: false)
        
        if let haveSuccessDetails = currentPageValue.response {
            updateUserDetailsArray(with: haveSuccessDetails)
        }
        nextButton.setTitle(Strings.Home.next, for: .normal)
        currentPage-=1
        
        if currentPage == 0 {
            backButton.isEnabled = false
        }
        
        vScrollView.setupUI(field: pageDetailsArray[currentPage])
    }
    
}
