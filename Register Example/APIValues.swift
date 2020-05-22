//
//  APIValues.swift
//  Register Example
//
//  Created by Example on 9/5/20.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

//// MARK: - APIValue
//struct APIValues: Codable {
//    let id: Int
//    let title: String
//    let fields: [Field]
//}
//
//// MARK: - Field
//struct Field: Codable {
//    let id: Int
//    let title, apiKey: String
//    let isMandatory: Bool
//    let inputType: String
//    let options: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, title, apiKey
//        case isMandatory = "is_mandatory"
//        case inputType = "input_type"
//        case options
//    }
//
//    enum KeyboardType {
//        case text, number, radio, checkBox
//    }
//
//    func keyboardType() -> KeyboardType {
//        switch inputType {
//        case "number":
//            return .number
//        case "radio":
//            return .radio
//        case "checkBox":
//            return .checkBox
//        default:
//            return .text
//        }
//    }
//}

// MARK: - APIValueElement
struct APIValueElement: Codable {
    let id: Int
    let title: String
    let fields: [Field]
}

// MARK: - Field
struct Field: Codable {
    let id: Int
    let title, apiKey: String
    let isMandatory: Bool
    let inputType: InputType
    let options: String?

    enum CodingKeys: String, CodingKey {
        case id, title, apiKey
        case isMandatory = "is_mandatory"
        case inputType = "input_type"
        case options
    }
}

enum InputType: String, Codable {
    case number = "number"
    case radio = "radio"
    case text = "text"
    case check = "check"
}

typealias APIValue = [APIValueElement]
