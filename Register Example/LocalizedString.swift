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
    }
    struct InputJSONError {
        static let invalidJSON = "Invalid JSON! Kindly check JSON key and value"
        static let error = "errorMessage"
        static let radioNotSelected = "is not selected"
        static let checkNotSelected = "is not selected, Select at-least one"
        static let textNotEntered = "is empty!"
    }
    struct Home {
        static let next = "Next"
        static let submit = "Submit"
        static let successRegistration = "Your registration successfully completed!"
    }
}
