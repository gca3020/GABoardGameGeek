//
//  GABoardGameGeek.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/6/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

open class GABoardGameGeek {

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
    open func getUserCollection(_ username: String, brief: Bool = false, stats: Bool = false, timeoutSeconds: Int = 90, closure: @escaping (ApiResult<[CollectionBoardGame]>) -> () ) {

        // Set up the initial request parameters
        var requestParams = [String: String]()
        requestParams["username"] = username.URLQueryString
        requestParams["brief"] = (brief ? "1" : "0")
        requestParams["stats"] = (stats ? "1" : "0")

        // Make the network call to get the collection.
        let endTime = Date().addingTimeInterval(Double(timeoutSeconds))
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
    open func getGamesById(_ ids: [Int], stats: Bool = false, closure: @escaping (ApiResult<[BoardGame]>) -> () ) {

        // Set up the request parameters
        var requestParams = [String: String]()
        requestParams["id"] = ids.map { String($0) }.joined(separator: ",")
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
    open func getGameById(_ id: Int, stats: Bool = false, closure: @escaping (ApiResult<BoardGame>) -> () ) {

        // Call the getter that takes an array, and validate that there was exactly one result
        getGamesById([id], stats: stats) { result in
            switch(result) {
            case .success(let gameCollection):
                if(gameCollection.count == 1) {
                    closure(.success(gameCollection[0]))
                } else {
                    closure(.failure(.apiError("Invalid Number of Items Returned: \(gameCollection.count)")))
                }
            case .failure(let error):
                closure(.failure(error))
            }
        }
    }

    // MARK: - Search

    open func searchFor(_ query: String, searchType: String? = nil, exactMatch: Bool = false, closure: @escaping (ApiResult<[SearchResult]>) -> () ) {

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
    fileprivate let api: ApiAdapter

    // MARK: - Constants

    /// The BGG URL to use when querying a user's collection
    fileprivate let collectionUrl = "https://boardgamegeek.com/xmlapi2/collection"

    /// The BGG URL to use when querying an item by ID
    fileprivate let itemUrl = "https://boardgamegeek.com/xmlapi2/thing"

    /// The BGG URL to use when performing a search
    fileprivate let searchUrl = "https://boardgamegeek.com/xmlapi2/search"
}
