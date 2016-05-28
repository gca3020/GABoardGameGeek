//
//  NetworkAdapter.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 5/28/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation
import Alamofire

internal class NetworkAdapter {

    /**
     Make an API request to the given URL with the specified parameters. The result
     is an asynchronous call to the supplied closure, taking an ApiResult.

     - parameter baseUrl: The base URL to make a call on. This does NOT include parameters
     - parameter params:  The parameters to make the call on. These should be URL Query Encoded already
     - parameter closure: The closure to call with the response
     */
    internal func urlRequest(baseUrl: String, params: [String: String], closure: ApiResult<String> -> ()) {
        Alamofire.request(.GET, baseUrl, parameters: params)
            .validate()
            .responseString { response in
                switch response.result {
                case .Success:
                    if let statusCode = response.response?.statusCode {
                        if( statusCode == 200 ) {
                            closure(.Success(response.result.value!))
                        }
                        else {
                            closure(.Failure(.ServerError(statusCode)))
                        }
                    }
                case .Failure(let error):
                    closure(.Failure(.ConnectionError(error)))
                }
        }
    }

}