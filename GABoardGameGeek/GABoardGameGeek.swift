//
//  GABoardGameGeek.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/6/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation
import SWXMLHash

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
        collectionRequest(requestParams, endTime: NSDate().dateByAddingTimeInterval(Double(timeoutSeconds))) { result in
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

        networkAdapter.urlRequest(self.itemUrl, params: requestParams) { result in
            switch(result) {
            case .Success(let resultString):
                do {
                    let parser = SWXMLHash.parse(resultString)
                    let gameList: [BoardGame] = try parser["items"]["item"].value()
                    closure(.Success(gameList))
                } catch {
                    closure(.Failure(.ApiError("Error Parsing XML Response")))
                }
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

     - parameter baseUrl: The Base URL of the request
     - parameter params:  The Encoded Params
     - parameter closure: The result closure
     */

    /**
     Make an API request specifically for a user collection. This function exists separately from the
     user callable function, since this will potentially be called multiple times while retrying.

     - parameter params:  The parameters of the Collection Request, already encoded as a URL
     - parameter endTime: The absolute end time and date that we should stop retrying.
     - parameter closure: The completion closure when we have either finished or failed
     */
    private func collectionRequest(params: [String: String], endTime: NSDate, closure: ApiResult<[CollectionBoardGame]> -> ()) {
        // Make the raw request, and handle the result
        networkAdapter.urlRequest(self.collectionUrl, params: params) { result in
            switch(result) {
            case .Success(let xmlString):
                do {
                    let parser = SWXMLHash.parse(xmlString)
                    let userGames: [CollectionBoardGame] = try parser["items"]["item"].value()
                    closure(.Success(userGames))
                } catch {
                    closure(.Failure(.ApiError("Error Parsing XML Response: \(error)")))
                }

            case .Failure(let error):
                switch(error) {
                case .ServerError(let statusCode):
                    // Special case for Collection Requests, a 202 status code means we should try again,
                    // so queue up a retry to happen in one second, as long as we're still below the timeout.
                    if( statusCode == 202 && (NSDate().compare(endTime) == NSComparisonResult.OrderedAscending) ) {
                        print("Making collection Request: Now=\(NSDate()), EndTime=\(endTime)")
                        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
                        dispatch_after(delay, dispatch_get_main_queue()) {
                            self.collectionRequest(params, endTime: endTime, closure: closure)
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