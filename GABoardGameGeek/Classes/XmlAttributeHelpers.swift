//
//  XmlAttributeHelpers.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/15/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation
import SWXMLHash

// MARK: - XML Attribute Deserializers

internal extension XMLElement {

    // Int
    internal func attribute(attribute: String) throws -> Int {
        guard let attributeStr = self.attributes[attribute], let ret = Int(attributeStr) else {
            throw XMLDeserializationError.NodeHasNoValue
        }
        return ret
    }
    // Int?
    internal func attribute(attribute: String) throws -> Int? {
        if let attributeStr = self.attributes[attribute] {
            return Int(attributeStr)
        }
        return nil
    }

    // Double
    internal func attribute(attribute: String) throws -> Double {
        guard let attributeStr = self.attributes[attribute], let ret = Double(attributeStr) else {
            throw XMLDeserializationError.NodeHasNoValue
        }
        return ret
    }
    // Double?
    internal func attribute(attribute: String) throws -> Double? {
        if let attributeStr = self.attributes[attribute] {
            return Double(attributeStr)
        }
        return nil
    }

    // String
    internal func attribute(attribute: String) throws -> String {
        guard let ret = self.attributes[attribute] else {
            throw XMLDeserializationError.NodeHasNoValue
        }
        return ret
    }
    // String?
    internal func attribute(attribute: String) throws -> String? {
        if let attributeStr = self.attributes[attribute] {
            return attributeStr
        }
        return nil
    }

    // Bool
    internal func attribute(attribute: String) throws -> Bool {
        guard let attributeStr = self.attributes[attribute] else {
            throw XMLDeserializationError.NodeHasNoValue
        }
        return NSString(string: attributeStr).boolValue
    }
    // Bool?
    internal func attribute(attribute: String) throws -> Bool? {
        if let attributeStr = self.attributes[attribute] {
            return NSString(string: attributeStr).boolValue
        }
        return nil
    }
}
