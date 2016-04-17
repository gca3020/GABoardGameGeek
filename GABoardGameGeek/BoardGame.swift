//
// Created by Geoffrey Amey on 4/17/16.
// Copyright (c) 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

// - Mark: BoardGame

/**
 * A structure defining a Board Game (or expansion, etc...) returned from an "item" query.
 * This is the standard format and contains all of the relevant information that a game has.
 * The statistics block is optional, and will only be present when a game is requested with
 * "stats=1" in the API request.
 */
public struct BoardGame {

    /// The object ID of this game. A unique identifier across the site.
    var objectId: Int

    /// The type of object this is. Commonly "boardgame", "boardgameexpansion", "boardgameaccessory"
    var type: String

    /// The name of this game. This is the primary name.
    var name: String

    /// The character of the name that the game should be sorted on. This is 1-indexed.
    var sortIndex: Int

    /// Path to the image for this game. This is not present if no image has been set for this game.
    /// - Note: This parameter should not be used to make a web request. Instead use the imageUrl computed param.
    var imagePath: String?

    /// Path to the thumbnail image for this game. Not guaranteed to be present.
    /// - Note: This parameter hsould not be used to make a web request. Instead use the thumbnailUrl computed param.
    var thumbnailPath: String?

    /// The game description.
    var description: String

    /// The year this game was published.
    var yearPublished: Int

    /// The minimum number of players supported by this game.
    var minPlayers: Int

    /// The maximum number of players supported by this game.
    var maxPlayers: Int

    /// The playing time for this game.
    var playingTime: Int

    /// The minimum playing time for this game.
    var minPlaytime: Int

    /// The maximum playing time for this game.
    var maxPlaytime: Int

    /// The minimum player age recommended for this game.
    var minAge: Int

    /// A poll for the suggested number of players that this game will play well with.
    var suggestedPlayers: SuggestedPlayersPoll

    /// A poll for the suggested minimum player age for this game.
    var suggestedPlayerage: SuggestedPlayeragePoll

    /// A poll for the language dependence of this game.
    var languageDependence: LanguageDependencePoll

    /// Links this game has to other site elements (publishers, designers, expansions, families, mechanics, etc...)
    var links: [BoardGameLink]

    /// Statistics for this game. Only present when stats=1 in the API request.
    var stats: Statistics?

    // - Mark: Computed Parameters

    /// The name that this game should be sorted on. For example, "The Gallerist" with a sortIndex of 5
    /// will be sorted simply as "Gallerist".
    var sortName: String {
        get { return Utils.getSortName(name, sortIndex: sortIndex) }
    }

    /// The NSURL to retrieve the game's image.
    /// - Note: Nil if the game has no imagePath, or if the imagePath is malformed.
    var imageUrl: NSURL? {
        get { return Utils.urlFrom(imagePath) }
    }

    /// The NSURL to retrieve the game's thumbnail image.
    /// - Note: Nil if the game has no thumbnailPath, or if the thumbnailPath is malformed.
    var thumbnailUrl: NSURL? {
        get { return Utils.urlFrom(thumbnailPath) }
    }
}

// - Mark: BoardGameLink

/**
 * A link from a game to something else (designer, publisher, mechanic, expansion, family, etc...)
 */
public struct BoardGameLink {
    /// The type of the game link. One of several types (probably not exhaustive)
    /// - boardgamecategory
    /// - boardgamemechanic
    /// - boardgamefamily
    /// - boardgameexpansion
    /// - boardgamecompilation
    /// - boardgamedesigner
    /// - boardgameartist
    /// - boardgamepublisher
    var type: String

    /// A unique identifier for the value of this link
    var id: Int

    /// The human-readable value for this link (e.g. if 'type' is `boardgamemechanic`,
    /// then 'value' might be `Set Collection`
    var value: String

    /// Whether this link is in-bound from another game. Commonly seen when this item
    /// is an expansion for another game.
    var inbound: Bool?
}

// - Mark: SuggestedPlayersPoll

/**
 * A user-poll for the suggested number of players. Contains information on Recommended and Best
 * player counts.
 */
public struct SuggestedPlayersPoll {

    /// The total number of votes in the poll.
    var totalVotes: Int

    /// A dictionary mapping the poll results to the number of players. This is mapped by string, rather
    /// than an integer, because the polls include things like `4+` meaning "more than 4"
    var results: [String: [PollResult]]?
}

// - Mark: SuggestedPlayeragePoll

/**
 * A user poll for the suggested minimum player age for this game.
 */
public struct SuggestedPlayeragePoll {

    /// The total number of votes in the poll.
    var totalVotes: Int

    /// A collection of poll results. Nil if no one has participated in the poll.
    var results: [PollResult]?
}

// - Mark: LanguageDependencePoll

/**
 * A user poll for the language dependence of this game.
 */
public struct LanguageDependencePoll {

    /// The total number of votes in the poll.
    var totalVotes: Int

    /// A collection of poll results. Nil if no one has participated in the poll.
    var results: [PollResult]?
}

// - Mark: PollResult

/**
 * A result in a poll.
 */
public struct PollResult {

    /// The 'level' for this result. Appears to only be present in a Language Dependece poll.
    /// A '1' implies that the game is not language dependent, a '5' implies it's very dependent.
    var level: Int?

    /// The value of the result. This is a human-readable string and will depend on the poll type.
    var value: String

    /// The number of votes for this particular result.
    var numVotes: Int
}

// - Mark: Statistics

/**
 * The site's recorded statistics for a game, if the game is retrieved from the API with stats=1
 */
public struct Statistics {

    /// The number of users who have rated this game.
    var usersRated: Int

    /// The average rating given to this game.
    var average: Double

    /// The bayesian (weighted) average rating for this game. Also known as the "GeekRating"
    var bayesAverage: Double

    /// The standard deviation in ratings for this game.
    var stdDev: Double

    /// The median rating for this game.
    /// - Note: Currently the site appears to always return `0` for this value.
    var median: Double

    /// The number of users that have marked this game as owned.
    var owned: Int

    /// The number of users that have this game for trade.
    var trading: Int

    /// The number of users that have marked this game as one they would like to receive in a trade.
    var wanting: Int

    /// The number of users that have added this game to their wishlist.
    var wishing: Int

    /// The number of user comments on this game.
    var numComments: Int

    /// The number of users who have submitted a "weight" for this game.
    var numWeights: Int

    /// The average "weight" of this game, submitted by users. Ratings are on a scale of 1-5,
    /// with 1 being the easiest to understand.
    var averageWeight: Double

    /// An array of ranks for this game, indicating its position on various lists.
    var ranks: [GameRank]
}