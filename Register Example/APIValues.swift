//
//  APIValues.swift
//  Register Example
//
//  Created by Example on 9/5/20.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

// MARK: - APIValueElement
struct APIValueElement: Codable {
    let id: Int
    let title: String
    var fields: [Field]
}

// MARK: - Field
struct Field: Codable {
    let id: Int
    let title, apiKey: String
    let isMandatory: Bool
    let inputType: InputType
    let options, regex, regexAlert: String?
    var userInput: String? = nil

    enum CodingKeys: String, CodingKey {
        case id, title, apiKey, regex, options
        case isMandatory = "is_mandatory"
        case inputType = "input_type"
        case regexAlert = "regex_alert"
    }
}

enum InputType: String, Codable {
    case number = "number"
    case radio = "radio"
    case text = "text"
    case check = "check"
    case password = "password"
}

typealias APIValue = [APIValueElement]
