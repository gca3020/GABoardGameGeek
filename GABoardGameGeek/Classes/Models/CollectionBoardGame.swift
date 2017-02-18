//
//  CollectionBoardGame.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/4/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

// MARK: - CollectionBoardGame

/**
 * A struct representing a board game retrieved from a user collection query. A collection
 * query can be different depending on several flags. Two of the flags that make the most
 * difference to the format of the results are "brief=1" and "stats=1". The structures below
 * document what I believe to be nearly complete (I am am missing some of the more obscure
 * optional fields like "wantparts"), with Swift optionals for the fields that are not
 * guaranteed to be present.
 */
public struct CollectionBoardGame {

    /// The object ID of this game.
    public var objectId: Int

    /// The name of this game.
    public var name: String

    /// The sort index of this game.
    public var sortIndex: Int

    /// The status of a game in a user's collection - Along with the name and ID,
    /// this is the only thing that is guaranteed to be there when querying a collection
    public var status: CollectionStatus
    
    /// The collection ID of this game.
    public var collId: Int

    /// Statistics for a game in a user's collection. These are formatted differently
    /// from the simple game lookup. 
    /// - Note: Not present when `stats` is not set
    public var stats: CollectionStats?

    /// The year a game was published. 
    /// - Note: Not present when `brief` is set
    public var yearPublished: Int?

    /// The path where the game's image can be accessed.
    /// - Note: Not present when `brief` is set
    /// - Note: This parameter should not be used to make a web request. Instead use the `imageUrl` computed param.
    public var imagePath: String?

    /// The path where the game's thumbnail-sized image can be accessed.
    /// - Note: Not present when `brief` is set
    /// - Note: This parameter should not be used to make a web request. Instead use the `thumbnailUrl` computed param.
    public var thumbnailPath: String?

    /// The number of plays a user has logged of the game. 
    /// - Note: Not present when `brief` is set
    public var numPlays: Int?

    /// If the user has commented on this game in their wishlist, this field will be populated.
    /// - Note: Not present when `brief` is set
    public var wishListComment: String?

    /// If the user has commented on this game in their collection, this field will be populated.
    /// - Note: Not present when `brief` is set
    public var comment: String?

    /// The sort-name of this game. A calculated parameter that indexes into the name by the sortIndex
    public var sortName: String {
        get { return name.getSortString(sortIndex) }
    }

    /// The `NSURL` to retrieve the game's image.
    /// - Note: `nil` if the game has no `imagePath`, or if the `imagePath` is malformed.
    public var imageUrl: URL? {
        get { return URL(fromBggUrlString: imagePath) }
    }

    /// The `NSURL` to retrieve the game's thumbnail image.
    /// - Note: `nil` if the game has no `thumbnailPath`, or if the `thumbnailPath` is malformed.
    public var thumbnailUrl: URL? {
        get { return URL(fromBggUrlString: thumbnailPath) }
    }
}

// MARK: - CollectionStatus

/**
 *  A struct representing the status of a game (owned, wishlist, etc...) in a user's collection
 */
public struct CollectionStatus {

    /// whether the user owns the game
    public var owned = false

    /// The user has previously owned the game
    public var prevOwned = false

    /// The user has the game marked as "want to buy"
    public var wantToBuy = false

    /// The user has the game marked as "want to play"
    public var wantToPlay = false

    /// The user has preordered the game
    public var preOrdered = false

    /// The user would like to get this game in trade
    public var wantInTrade = false

    /// The user owns this game and has it listed for trade.
    public var forTrade = false

    /// The game is in this user's wishlist.
    public var wishList = false

    /// The priority of this game in a user's wish list. 
    /// - Note: Not present when `wishList` is `false`
    public var wishListPriority: Int?

    /// The most recent date this item in the collection was modified
    public var lastModified = ""
}

// MARK: - CollectionStats

/**
 *  A class representing the statistics of a game, pulled when requesting the collection with the
 *  `stats` param set.
 */
public struct CollectionStats {

    /// The minimum number of players this game supports
    public var minPlayers: Int?

    /// The maximum number of players this game supports
    public var maxPlayers: Int?

    /// The minimum playtime listed for this game
    public var minPlaytime: Int?

    /// The maximum playtime listed for this game
    public var maxPlaytime: Int?

    /// The listed playing time for this game
    public var playingTime: Int?

    /// The number of users that own this game
    public var numOwned: Int

    /// The ratings and rankings for this game.
    public var rating: CollectionRating
}

// MARK: - CollectionRating

/**
 *  A class representing the ratings of a game, pulled when requesting the collection with the
 *  `stats` param set.
 */
public struct CollectionRating {

    /// The user's rating for this game. 
    /// - Note: If the user has not rated this game, it will be 0.0
    public var userRating: Double?

    /// The number of users that have rated this game. 
    /// - Note: Not present when `brief` is set
    public var usersRated: Int?

    /// The average rating given to this game. 
    /// - Note: Not present when `brief` is set
    public var averageRating: Double

    /// The weighted "Geek Rating" given to this game. 
    /// - Note: Not present when `brief` is set
    public var bayesAverageRating: Double

    /// The standard deviation of the rating for this game. 
    /// - Note: Not present when `brief` is set
    public var stdDev: Double?

    /// The median rating given to this game. 
    /// - Note: Not present when `brief` is set
    /// - Note: I have never seen this be non-zero.
    public var median: Double?

    /// This game's ranking within various lists. 
    /// - Note: Not present when `brief` is set
    public var ranks: [GameRank]?
}
