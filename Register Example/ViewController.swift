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
        vScrollView.setupUI(field: jsonInput![currentPage])
        
        view.addSubview(titleLabel)
        view.addSubview(vScrollView)
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
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
        // Invoke a method in ScrollView class
        // This method validate all the current page field and return alert message as Dict
        // If all fields are valided and return valid API dict details
        let currentResponseDict = vScrollView.nextButtonTapped()
        
        // If response dict containts only one key and key is eqaul to "error" then show alert message
        // Else current page doesn't have any issue good to go for next page or registration success menssage
        if currentResponseDict.keys.count == 1,
            let haveValue = currentResponseDict[Strings.InputJSONError.error] as? String {
            showAlert(message: haveValue)
        } else {
            // Merging previous response page dict key (if available) to new dict key
            responseToAPIDict = responseToAPIDict.merging(currentResponseDict, uniquingKeysWith: { (_, last) in last })
            
            if let haveJsonInput = jsonInput {
                // If currentPage reach last count for JSON then show success message for registration
                // Else increase currentPage value and recreate UI based on that JSON value
                if currentPage >= (haveJsonInput.count-1) {
                    showAlert(message: Strings.Home.successRegistration)
                } else {
                    currentPage+=1
                    vScrollView.setupUI(field: haveJsonInput[currentPage])
                }
            }
        }
    }
}
