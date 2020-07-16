//
//  LocalizedString.swift
//  Register Example
//
//  Created by Example on 9/5/20.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

struct Strings {
    struct Common {
        static let appName = "Register Example"
    }
    
    struct Alert {
        static let okey = "Okey"
        static let cancel = "Cancel"
        static let done = "Done"
        static let somethingWentWrong = "Something went wrong!, Try again."
    }
    struct InputJSONError {
        static let success = "Success"
        static let invalidJSON = "Invalid JSON! Kindly check JSON key and value"
        static let message = "message"
        static let radioNotSelected = "is not selected"
        static let checkNotSelected = "is not selected, Select at-least one"
        static let textNotEntered = "is empty!"
        static let notValidText = "is not valid one"
    }
    struct Home {
        static let next = "Next"
        static let back = "Back"
        static let submit = "Submit"
        static let successRegistration = "Your registration successfully completed!"
    }
}
