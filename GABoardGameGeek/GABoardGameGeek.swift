//
//  GABoardGameGeek.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/6/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation
import SWXMLHash
import Alamofire

public class GABoardGameGeek {

    // MARK: - API Functions

    /**
     Make a request for a user's collection, returning the results in a ApiResult on a closure.

     - parameter username: The username to request collection data from
     - parameter brief:    true if we should request the brief collection, false otherwise
     - parameter stats:    true if we should request stats, false otherwise
     - parameter closure:  The closure to call when the results have been obtained or an error has occured.
     */
    public func getUserCollection(username: String, brief: Bool = false, stats: Bool = false, closure: ApiResult<[CollectionBoardGame]> -> ()) {

        // Set up the initial request parameters
        var requestParams = [String: String]()
        requestParams["username"] = username.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        requestParams["brief"] = (brief ? "1" : "0")
        requestParams["stats"] = (stats ? "1" : "0")

        // Make the network call to get the collection.
        collectionRequest(requestParams, initialRequestTime: NSDate()) { result in
            closure(result)
        }
    }

    // MARK: - Initializers

    /**
     The standard initializer for a GABoardGameGeek instance. Useful when overriding the default 
     timeout value, or for

     - parameter apiTimeout: The desired timeout in seconds for network requests.

     - returns: A GABoardGameGeek instance to use for making API requests
     */
    init(apiTimeout: Int = 60, urlSession: NSURLSession? = nil) {
        self.timeoutInSeconds = apiTimeout

        // Use the timeout to create the manager that Alamofire will use
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.timeoutIntervalForRequest = Double(apiTimeout)
        afManager = Alamofire.Manager(configuration: sessionConfig)
    }

    // MARK: - Private Functions

    /**
     Make an API request specifically for a user collection. This function exists separately from the 
     user callable function, since this will potentially be called multiple times while retrying.

     - parameter baseUrl: The Base URL of the request
     - parameter params:  The Encoded Params
     - parameter closure: The result closure
     */
    private func collectionRequest(params: [String: String], initialRequestTime: NSDate, closure: ApiResult<[CollectionBoardGame]> -> ()) {
        let elapsedTimeInterval = NSDate().timeIntervalSinceDate(initialRequestTime)

        // Make the raw request, and handle the result
        rawRequest(self.collectionUrl, params: params) { result in
            switch(result) {
            case .Success(let xmlString):
                do {
                    let parser = SWXMLHash.parse(xmlString)
                    let userGames: [CollectionBoardGame] = try parser["items"]["item"].value()
                    closure(.Success(result: userGames))
                } catch {
                    closure(.ApiError(message: "Error Parsing XML Response"))
                }

            case .ServerError(let statusCode):
                // Special case for Collection Requests, a 202 status code means we should try again,
                // so queue up a retry to happen in one second, as long as we're still below the timeout.
                if( statusCode == 202 && (Int(elapsedTimeInterval) < self.timeoutInSeconds-1) ) {
                    print("Received 202 Status Code... Time Elapsed: \(elapsedTimeInterval)")
                    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
                    dispatch_after(delay, dispatch_get_main_queue()) {
                        self.collectionRequest(params, initialRequestTime: initialRequestTime, closure: closure)
                    }
                }
                else {
                    closure(.ServerError(statusCode: statusCode))
                }

            case .ConnectionError(let error):
                closure(.ConnectionError(error: error))
            case .ApiError(let message):
                closure(.ApiError(message: message))
            }
        }
    }

    /**
     Make an API request to the given URL with the specified parameters. The result
     is an asynchronous call to the supplied closure, taking an ApiResult.

     - parameter baseUrl: The base URL to make a call on. This does NOT include parameters
     - parameter params:  The parameters to make the call on. These should be URL Query Encoded already
     - parameter closure: The closure to call with the response
     */
    private func rawRequest(baseUrl: String, params: [String: String], closure: ApiResult<String> -> ()) {
        afManager.request(.GET, baseUrl, parameters: params)
            .validate()
            .responseString { response in
                switch response.result {
                case .Success:
                    if let statusCode = response.response?.statusCode {
                        if( statusCode == 200 ) {
                            closure(.Success(result: response.result.value!))
                        }
                        else {
                            closure(.ServerError(statusCode: statusCode))
                        }
                    }
                case .Failure(let error):
                    closure(.ConnectionError(error: error))
                }
        }
    }

    // MARK: - Private Member Variables

    /// The number of seconds we should wait on an API call before declaring it a failure.
    private let timeoutInSeconds: Int

    /// The Alamofire manager to use for all of our network requests
    private let afManager: Alamofire.Manager

    /// The BGG URL to use when querying a user's collection
    private let collectionUrl = "https://boardgamegeek.com/xmlapi2/collection"

    /// The BGG URL to use when querying an item by ID
    private let itemUrl = "https://boardgamegeek.com/xmlapi2/thing"
}