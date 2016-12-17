//
//  Utils.swift
//  GABoardGameGeek
//
// Created by Geoffrey Amey on 4/17/16.
// Copyright (c) 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

internal extension String {
    /// Get a string encoded for URL Requests
    var URLQueryString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }

    /// Get a string with whitespace trimmed off
    var trimWhitespace: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

internal extension String {
    /**
     Gets a string that has been advanced by an offset so it can be sorted alphabetically.
     The offset is 1-indexed, and if it is invalid, the original string will be returned.

     - parameter sortIndex: The n'th character of the string to sort on (1-indexed)

     - returns: A substring that can be sorted alphabetically.
     */
    func getSortString(_ sortIndex: Int) -> String {
        if sortIndex <= 1 || sortIndex > self.characters.count {
            return self
        } else {
            return self.substring(from: self.characters.index(self.startIndex, offsetBy: sortIndex - 1))
        }
    }
}

internal extension URL {
    /**
     Failable initializer for an NSURL given a BGG URL String (one which is missing the protocol).

     - parameter fromBggUrlString: The URL Path, without the protocol

     - returns: A fully-formed NSURL based on the given string, or nil if anything failed.
     */
    init?(fromBggUrlString: String?) {
        guard let urlString = fromBggUrlString else {
            return nil
        }

        self.init(string: "http:\(urlString)")
    }
}
