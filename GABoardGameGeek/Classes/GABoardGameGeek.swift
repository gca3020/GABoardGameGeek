//
//  GABoardGameGeek.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/6/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

public class GABoardGameGeek {

    // MARK: - User Collections

    /**
     Make a request for a user's collection, given the username

     - parameter username:       The username to request collection data from
     - parameter brief:          `true` if we should request the brief collection, `false` otherwise
     - parameter stats:          `true` if we should request stats, `false` otherwise
     - parameter timeoutSeconds: The number of seconds we should retry the request if the site responds that it is still processing
     - parameter closure:        Async return of an `ApiResult<[CollectionBoardGame]>` containing `.Success(Value)`
                                 on a successful call, or `.Failure(BggError)` if something went wrong.
     
     - NOTE: The closure executes on the main thread by default.
     */
    public func getUserCollection(username: String, brief: Bool = false, stats: Bool = false, timeoutSeconds: Int = 90, closure: ApiResult<[CollectionBoardGame]> -> () ) {

        // Set up the initial request parameters
        var requestParams = [String: String]()
        requestParams["username"] = username.URLQueryString
        requestParams["brief"] = (brief ? "1" : "0")
        requestParams["stats"] = (stats ? "1" : "0")

        // Make the network call to get the collection.
        let endTime = NSDate().dateByAddingTimeInterval(Double(timeoutSeconds))
        api.request(self.collectionUrl, params: requestParams, rootElement: "items", childElement: "item", retryUntil: endTime, closure: closure)
    }

    // MARK: - Items

    /**
     Get a list of games, given a list of game IDs.

     - parameter ids:     An array of integer game IDs to query
     - parameter stats:   `true` if we should request game statistics
     - parameter closure: Async return of an `ApiResult<[BoardGame]>` containing `.Success(Value)` on a 
                          successful call, or `.Failure(BggError)` if something went wrong.

     - NOTE: The closure executes on the main thread by default.
     */
    public func getGamesById(ids: [Int], stats: Bool = false, closure: ApiResult<[BoardGame]> -> () ) {

        // Set up the request parameters
        var requestParams = [String: String]()
        requestParams["id"] = ids.map { String($0) }.joinWithSeparator(",")
        requestParams["stats"] = (stats ? "1" : "0")

        // Make the request
        api.request(self.itemUrl, params: requestParams, rootElement: "items", childElement: "item", closure: closure)
    }

    /**
     Retrieve the details of a single game, given its ID.

     - parameter id:      The ID of the game to request
     - parameter stats:   true if we should request game statistics
     - parameter closure: Async return of an `ApiResult<BoardGame>` containing `.Success(Value)` on a
                          successful call, or `.Failure(BggError)` if something went wrong.

     - NOTE: The closure executes on the main thread by default.
     */
    public func getGameById(id: Int, stats: Bool = false, closure: ApiResult<BoardGame> -> () ) {

        // Call the getter that takes an array, and validate that there was exactly one result
        getGamesById([id], stats: stats) { result in
            switch(result) {
            case .Success(let gameCollection):
                if(gameCollection.count == 1) {
                    closure(.Success(gameCollection[0]))
                } else {
                    closure(.Failure(.ApiError("Invalid Number of Items Returned: \(gameCollection.count)")))
                }
            case .Failure(let error):
                closure(.Failure(error))
            }
        }
    }

    // MARK: - Search

    public func searchFor(query: String, searchType: String? = nil, exactMatch: Bool = false, closure: ApiResult<[SearchResult]> -> () ) {

        // Set up the request parameters
        var requestParams = [String: String]()

        requestParams["query"] = query.URLQueryString
        if let unwrappedSearchType = searchType {
            requestParams["type"] = unwrappedSearchType.URLQueryString
        }
        requestParams["exact"] = (exactMatch ? "1" : "0")

        // Make the request
        api.request(self.searchUrl, params: requestParams, rootElement: "items", childElement: "item", closure: closure)
    }


    // MARK: - Initializers

    /**
     Initialize the `GABoardGameGeek` API

     - returns: A `GABoardGameGeek` instance ready to handle API requests
     */
    public init() {
        self.api = ApiAdapter()
    }

    // MARK: - Private Member Variables

    /// An `ApiAdapter` to separate out all of the internal Networking and XML Parsing Functionality
    private let api: ApiAdapter

    // MARK: - Constants

    /// The BGG URL to use when querying a user's collection
    private let collectionUrl = "https://boardgamegeek.com/xmlapi2/collection"

    /// The BGG URL to use when querying an item by ID
    private let itemUrl = "https://boardgamegeek.com/xmlapi2/thing"

    /// The BGG URL to use when performing a search
    private let searchUrl = "https://boardgamegeek.com/xmlapi2/search"
}