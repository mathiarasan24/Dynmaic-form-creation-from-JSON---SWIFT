//
//  ViewController+Extension.swift
//  Register Example
//
//  Created by Example on 9/5/20.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(message: String,
                   title: String = Strings.Common.appName,
                   positiveTitle: String = Strings.Alert.okey,
                   positiveAction: ((UIAlertAction) -> Void)? = nil,
                   negativeTitle: String? = nil,
                   negetiveAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: positiveTitle, style: UIAlertAction.Style.default, handler: positiveAction))
        
        if let haveNegative = negativeTitle {
            alert.addAction(UIAlertAction(title: haveNegative, style: UIAlertAction.Style.cancel, handler: negetiveAction))
        }
        
        present(alert, animated: true, completion: nil)
    }
}

extension UIButton {
    
    class func buttonInit(title: String,
                          bgColor: UIColor = .gray,
                          textColor: UIColor = .black) -> UIButton {
        let returnButton = UIButton(type: .custom)
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        returnButton.setTitle(title, for: .normal)
        returnButton.backgroundColor = bgColor
        returnButton.setTitleColor(textColor, for: .normal)
        
        return returnButton
    }
    
}

extension UIView {
    
    class func viewInit(bgColor: UIColor = .white) -> UIView {
        let returnView = UIView()
        returnView.translatesAutoresizingMaskIntoConstraints = false
        returnView.backgroundColor = bgColor
        return returnView
    }
}

extension UIControl {
    
    class func controlInit(bgColor: UIColor = .clear) -> UIControl {
        let returnView = UIControl()
        returnView.translatesAutoresizingMaskIntoConstraints = false
        returnView.backgroundColor = bgColor
        returnView.isExclusiveTouch = true
        
        return returnView
    }
}

extension UIImageView {
    
    class func imageViewInit(imageName: String,
                             bgColor: UIColor = .clear) -> UIImageView {
        let returnView = UIImageView(image: UIImage(named: imageName))
        returnView.translatesAutoresizingMaskIntoConstraints = false
        returnView.backgroundColor = bgColor
        
        return returnView
    }
}

extension UILabel {
    
    class func lableInit(title: String,
                         bgColor: UIColor = .clear,
                         textColor: UIColor = .black) -> UILabel {
        let returnView = UILabel()
        returnView.translatesAutoresizingMaskIntoConstraints = false
        returnView.backgroundColor = bgColor
        returnView.textColor = textColor
        returnView.text = title
        
        return returnView
    }
}

extension UITextField {
    
    class func textFieldInit(placeHolder: String,
                             bgColor: UIColor = .lightGray,
                             text: String? = nil) -> UITextField {
        let returnView = UITextField()
        returnView.translatesAutoresizingMaskIntoConstraints = false
        returnView.backgroundColor = bgColor
        returnView.text = text
        returnView.placeholder = placeHolder
        returnView.borderStyle = .roundedRect
        
        return returnView
    }
}

extension UIToolbar {
    
    class func doneButton(target: Any?, action: Selector?) -> UIToolbar{
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: Strings.Alert.done, style: .done, target: target, action: action)
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        return doneToolbar
    }
}
