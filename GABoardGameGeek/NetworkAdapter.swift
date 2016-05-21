//
//  NetworkAdapter.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/24/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation
import Alamofire

class NetworkAdapter {

    /**
     Make an API request to the given URL with the specified parameters. The result
     is an asynchronous call to the supplied closure, taking an ApiResult.

     - parameter baseUrl: <#baseUrl description#>
     - parameter params:  <#params description#>
     - parameter closure: <#closure description#>
     */
    func makeRequest(baseUrl: String, params: [String: String], closure: ApiResult<String> -> ()) {
        print( "makeRequest")
        Alamofire.request(.GET, baseUrl, parameters: params)
            .validate(statusCode: 200..<202)
            .responseString { response in
                switch response.result {
                case .Success:
                    print("Validation Successful")
                    closure(.Success(result: response.result.value!))
                case .Failure(let error):
                    print(error)
                }

        }
    }

}