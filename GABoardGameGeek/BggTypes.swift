//
//  BggTypes.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/3/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

/**
 * An enumeration to hold the results of making an API call into the BGG XMLAPI2
 *
 * - Success: The API operation was successful.
 * - ConnectionError: There were network connectivity issues. The Network or Server may be down.
 * - ServerError: We connected to the server, but it returned a non-200 HTTP Status Code (e.g. 404, 502)
 * - ApiError: Any error parsing the server response, or any other error that indicates a failure.
 *             This could be something like an invalid username, etc...
 */
public enum BggResult<Type>: ErrorType {
    case Success(result: Type)
    case ConnectionError(error: NSError)
    case ServerError(statusCode: Int)
    case ApiError(message: String)
}
