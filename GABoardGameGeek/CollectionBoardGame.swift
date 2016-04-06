//
//  CollectionBoardGame.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/4/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

// MARK: - CollectionBoardGame

public class CollectionBoardGame: BoardGame {

    // MARK: - Data Members

    /// The status of a BoardGame in a user's collection - Along with the name and ID,
    /// this is the only thing that is guaranteed to be there when querying a collection
    var status: CollectionStatus

    /// Statistics for a game in a user's collection. These are formatted differently
    /// from the simple game lookup. Not present when stats=0
    var stats: CollectionStats?

    /// The year a game was published. Not present when brief=1
    var yearPublished: Int?

    /// The URL where the game image can be accessed. Not present when brief=1
    var imageUrl: NSURL?

    /// The URL where the game thumbnail image can be accessed. Not present when brief=1
    var thumbnailUrl: NSURL?

    /// The number of plays a user has logged of the game. Not present when brief=1
    var numPlays: Int?

    /// If the user has commented on this game in their wishlist, this field will be populated.
    /// Not present when brief=1
    var wishListComment: String?

    /// If the user has commented on this game in their collection, this field will be populated.
    /// Not present when brief=1
    var comment: String?

    // MARK: - Initializers

    /**
     Basic initializer for a CollectionBoardGame object. This primarily just calls the
     Superclass initializer fills in the defaults for a CollectionStatus

     - parameter objectId:  The object ID of this game.
     - parameter name:      The name of this game.
     - parameter sortIndex: The character in the name to sort on (1-indexed)

     - returns: A CollectionBoardGame
     */
    override init(objectId: Int, name: String, sortIndex: Int = 1) {
        self.status = CollectionStatus()
        super.init(objectId: objectId, name: name, sortIndex: sortIndex)
    }
}

// MARK: - CollectionStatus

/**
 *  A struct representing the status of a game (owned, wishlist, etc...) in a user's collection
 */
public struct CollectionStatus {

    /// whether the user owns the game
    var owned = false

    /// The user has previously owned the game
    var prevOwned = false

    /// The user has the game marked as "want to buy"
    var wantToBuy = false

    /// The user has the game marked as "want to play"
    var wantToPlay = false

    /// The user has preordered the game
    var preOrdered = false

    /// The user would like to get this game in trade
    var wantInTrade = false

    /// The user owns this game and has it listed for trade.
    var forTrade = false

    /// The game is in this user's wishlist.
    var wishList = false

    /// The priority of this game in a user's wish list. Not present when wishList=false
    var wishListPriority: Int?

    /// The most recent date this item in the collection was modified
    var lastModified = ""
}

// MARK: - CollectionStats

/**
 *  A class representing the statistics of a game, pulled when requesting the collection with the
 * "stats=1" flag. If brief stats are pulled, this structure will contain only the non-optional members.
 */
public struct CollectionStats {

    /// The minimum number of players this game supports
    var minPlayers = 0

    /// The maximum number of players this game supports
    var maxPlayers = 0

    /// The minimum playtime listed for this game
    var minPlaytime = 0

    /// The maximum playtime listed for this game
    var maxPlaytime = 0

    /// The listed playing time for this game
    var playingTime = 0

    /// The number of users that own this game
    var numOwned = 0

    /// The user's rating for this game. If the user has not rated this game, it will be 0.0
    var userRating = 0.0

    /// The number of users that have rated this game. Not present when brief=1
    var usersRated: Int?

    /// The average rating given to this game. Not present when brief=1
    var averageRating: Double?

    /// The weighted "Geek Rating" given to this game. Not present when brief=1
    var bayesAverageRating: Double?

    /// The standard deviation of the rating for this game. Not present when brief=1
    var stdDev: Double?

    /// The median rating given to this game. Not present when brief=1
    /// - Note: I have never seen this be non-zero.
    var median: Double?

    /// This game's ranking within various lists. Not present when brief=1
    var ranks: [GameRank]?
}