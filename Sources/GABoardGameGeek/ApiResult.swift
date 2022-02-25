//
//  ApiResult.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/3/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

/**
 An enumeration to hold the results of making an API call into the BGG XMLAPI2

 - NOTE: Credit for this pattern (as well as the code) goes to Alamofire.
 */
public enum ApiResult<Value> {

    /**
     The call was successful.

     - returns: The deserialized results, of type `Value`
     */
    case success(Value)

    /**
     The call failed.

     - returns: A `BggError` containing the error type and any additional details.
     */
    case failure(BggError)

    /// Returns `true` if this `ApiResult` is `.Success`, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    /// Returns `true` if this `ApiResult` is `.Failure`, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }

    /// Returns the associated `Value` if this `ApiResult` is `.Success`, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    /// Returns the associated `BggError` if this `ApiResult` is `.Failure`, `nil` otherwise.
    public var error: BggError? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }

}

/**
 An enumeration to hold a more detailed description of an error when an API call fails.
 */
public enum BggError: Error, Equatable {

    /**
     There were network connectivity errors. The Network or Server may be down, or responding with
     a bad status code.

     - returns: an `AFError` containing additional details from the Network Request
     */
    // TODO: Return some indication of the underlying AFError
    case connectionError

    /**
     The server is not ready, and has returned a 202 HTTP Status Code, indictaing that it has
     accepted our request, but has not yet processed it, and we should try again later.
     */
    case serverNotReady

    /**
     The API returned an error of some sort. Details are available in the description

     - returns: A `String` with details of the error returned by the API
     */
    case apiError(String)

    /**
     There was an error parsing the XML response. This can indicate that the data models may be 
     incorrect, or possibly that the XMLAPI has changed.

     - returns: A `String` with details of the XML Parsing Error.
     */
    case xmlError(String)
}

/**
 Provide the Equality operator for the `BggError` enumeration

 - parameter a: The `BggError` lvalue
 - parameter b: The `BggError` rvalue

 - returns: A `Bool` indicating if the two values are equal
 */
public func ==(a: BggError, b: BggError) -> Bool {
    switch(a, b) {
    //case(.connectionError(let a), .connectionError(let b)):
    //    return a == b
    case(.connectionError, .connectionError):
        return true;
    case(.serverNotReady, .serverNotReady):
        return true
    case(.apiError(let a), .apiError(let b)):
        return a == b
    case(.xmlError(let a), .xmlError(let b)):
        return a == b
    default:
        return false
    }
}

