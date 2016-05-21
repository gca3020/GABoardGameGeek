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
    var adapter: NetworkAdapter = NetworkAdapter()

    public func getUserCollection(username: String, closure: ApiResult<[CollectionBoardGame]> -> ()) {
        let collectionUrl = "https://boardgamegeek.com/xmlapi2/collection"
        var requestParams = [String: String]()

        // Set up the initial request parameters
        requestParams["username"] = username.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        requestParams["brief"] = "1"

        // Make the call to the network adapter to get the XML to parse
        adapter.makeRequest(collectionUrl, params: requestParams) { result in
            switch(result) {
            case .Success(let xmlString):
                do {
                    print(xmlString)
                    let parser = SWXMLHash.parse(xmlString)
                    let userGames: [CollectionBoardGame] = try parser["items"]["item"].value()
                    print(userGames)
                    closure(.Success(result: userGames))
                } catch {
                    closure(.ApiError(message: "Error Parsing HTML Response"))
                }

            case .ConnectionError(let error):
                closure(.ConnectionError(error: error))
            case .ServerError(let statusCode):
                closure(.ServerError(statusCode: statusCode))
            case .ApiError(let message):
                closure(.ApiError(message: message))
            }
        }
    }

}