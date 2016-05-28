//
//  BoardGameGeekTypes.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/3/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

public enum ApiResult<Value> {
    case Success(Value)
    case Failure(BggError)
}

/**
 * An enumeration to hold the results of making an API call into the BGG XMLAPI2
 *
 * - ConnectionError: There were network connectivity issues. The Network or Server may be down.
 * - ServerError: We connected to the server, but it returned a non-200 HTTP Status Code (e.g. 404, 502)
 * - ApiError: Any error parsing the server response, or any other error that indicates a failure.
 *             This could be something like an invalid username, etc...
 * - XmlError: An error when parsing the XML into a specific type
 */
public enum BggError: ErrorType {
    case ConnectionError(NSError)
    case ServerError(Int)
    case ApiError(String)
    case XmlError(String)
}