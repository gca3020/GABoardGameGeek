//
//  SearchResult.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 6/12/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

/**
 *  A structure defining a result returned from a search query.
 */
public struct SearchResult {

    /// The type of item this search result refers to. 
    /// Types might include "boardgame", "boardgameexpansion", and "videogame"
    public var itemType: String

    /// The unique site identifier used to request additional information about a search result
    public var objectId: Int

    /// The type of this name, "primary" or "alternate"
    public var nameType: String

    /// The name of the item returned from the search result
    public var name: String

    /// The publication year for this item. Not present on all types of results.
    public var yearPublished: Int?
}