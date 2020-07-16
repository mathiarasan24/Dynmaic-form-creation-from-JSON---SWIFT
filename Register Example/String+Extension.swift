//
//  String+Extension.swift
//  Register Example
//
//  Created by Infra SG on 16/7/20.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

extension String {
    
    func isValidExpression(_ regex: String) -> Bool {
        do {
            let regularExpression = try NSRegularExpression(pattern: regex)
            
            return regularExpression.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }
    
}
