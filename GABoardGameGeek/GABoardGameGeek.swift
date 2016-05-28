//
//  GABoardGameGeek.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/6/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

public class GABoardGameGeek {

    // MARK: - API Functions

    /**
     Make a request for a user's collection, returning the results on a success, or a non-
     Success ApiResult on a failure.

     - parameter username:       The username to request collection data from
     - parameter brief:          true if we should request the brief collection, false otherwise
     - parameter stats:          true if we should request stats, false otherwise
     - parameter timeoutSeconds: The number of seconds we should retry the request if the site responds that it is still processing
     - parameter closure:        The closure to call when the results have been obtained or an error has occured.
     */
    public func getUserCollection(username: String, brief: Bool = false, stats: Bool = false, timeoutSeconds: Int = 90, closure: ApiResult<[CollectionBoardGame]> -> () ) {

        // Set up the initial request parameters
        var requestParams = [String: String]()
        requestParams["username"] = username.URLQueryString
        requestParams["brief"] = (brief ? "1" : "0")
        requestParams["stats"] = (stats ? "1" : "0")

        // Make the network call to get the collection.
        let endTime = NSDate().dateByAddingTimeInterval(Double(timeoutSeconds))
        collectionRequest(requestParams, retryUntil: endTime) { result in
            closure(result)
        }
    }

    /**
     Get a list of games, given a list of game IDs.

     - parameter ids:     An array of integer game IDs to query
     - parameter stats:   true if we should request game statistics
     - parameter closure: The closure to call when the results have been obtained or an error has occured.
     */
    public func getGamesById(ids: [Int], stats: Bool = false, closure: ApiResult<[BoardGame]> -> () ) {

        // Set up the request parameters
        var requestParams = [String: String]()
        requestParams["id"] = ids.map { String($0) }.joinWithSeparator(",")
        requestParams["stats"] = (stats ? "1" : "0")

        // Make the request
        networkAdapter.requestData(self.itemUrl, params: requestParams) { result in
            switch(result) {
            case .Success(let resultString):
                closure(self.xmlAdapter.parse(resultString, rootElement: "items", childElement: "item"))
            case .Failure(let error):
                closure(.Failure(error))
            }
        }
    }

    // MARK: - Initializer
    init() {
        self.networkAdapter = NetworkAdapter()
        self.xmlAdapter = XmlAdapter()
    }

    // MARK: - Private Functions

    /**
     Make an API request specifically for a user collection. This function exists separately from the
     user callable function, since this will potentially be called multiple times while retrying.

     - parameter params:     The parameters of the Collection Request, already encoded as a URL
     - parameter retryUntil: The absolute end time after which we should stop retrying.
     - parameter closure:    The completion closure when we have either finished or failed
     */
    private func collectionRequest(params: [String: String], retryUntil: NSDate, closure: ApiResult<[CollectionBoardGame]> -> ()) {
        // Make the raw request, and handle the result
        networkAdapter.requestData(self.collectionUrl, params: params) { result in
            switch(result) {
            case .Success(let xmlString):
                closure(self.xmlAdapter.parse(xmlString, rootElement: "items", childElement: "item"))
            case .Failure(let error):
                switch(error) {
                case .ServerNotReady:
                    // Special case for Collection Requests, a 202 status code means we should try again,
                    // so queue up a retry to happen in one second, as long as we're still below the timeout.
                    if( (NSDate().compare(retryUntil) == NSComparisonResult.OrderedAscending) ) {
                        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
                        dispatch_after(delay, dispatch_get_main_queue()) {
                            self.collectionRequest(params, retryUntil: retryUntil, closure: closure)
                        }
                    }
                    else {
                        closure(.Failure(error))
                    }
                default:
                    closure(.Failure(error))
                }
            }
        }
    }

    // MARK: - Private Member Variables

    /// A Network Adapter to separate out all of the networking functionality of the API
    private let networkAdapter: NetworkAdapter

    /// An XML Adapter to separate out all of the XML parsing code
    private let xmlAdapter: XmlAdapter

    /// The BGG URL to use when querying a user's collection
    private let collectionUrl = "https://boardgamegeek.com/xmlapi2/collection"

    /// The BGG URL to use when querying an item by ID
    private let itemUrl = "https://boardgamegeek.com/xmlapi2/thing"
}