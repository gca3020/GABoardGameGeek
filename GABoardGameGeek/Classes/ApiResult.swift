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

 - Success: The call was successful. The value contains the deserialized results
 - Failure: The call failed. BggError contains the error enumeration with additional details
 */
public enum ApiResult<Value> {
    case Success(Value)
    case Failure(BggError)
}

/**
 An enumeration to hold a more detailed description of an error when an API call fails.

 - ConnectionError: There were network connectivity errors. The Network or Server may be down, or
                    responding with a bad status code. The NSError returned with this will contain
                    additional details.
 - ServerNotReady:  The server returned a 202 HTTP Status code, indicating that it has accepted our
                    request, but has not yet processed it, and we should retry later. This happens
                    very frequently with User Collection requests.
 - ApiError:        The API returned an error of some sort. Details are available in the description.
 - XmlError:        There was an error parsing the XML response. This can indicate that the data models
                    are incorrect, or possibly that the XMLAPI has changed.
 */
public enum BggError: ErrorType {
    case ConnectionError(NSError)
    case ServerNotReady
    case ApiError(String)
    case XmlError(String)
}