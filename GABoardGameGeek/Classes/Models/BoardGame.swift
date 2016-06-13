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
 * `stats` set to `true` in the API request.
 */
public struct BoardGame {

    /// The object ID of this game. A unique identifier across the site.
    public var objectId: Int

    /// The type of object this is. Commonly "boardgame", "boardgameexpansion", "boardgameaccessory"
    public var type: String

    /// The name of this game. This is the primary name.
    public var name: String

    /// The character of the name that the game should be sorted on. This is 1-indexed.
    public var sortIndex: Int

    /// Path to the image for this game. This is not present if no image has been set for this game.
    /// - Note: This parameter should not be used to make a web request. Instead use the `imageUrl` computed param.
    public var imagePath: String?

    /// Path to the thumbnail image for this game. Not guaranteed to be present.
    /// - Note: This parameter should not be used to make a web request. Instead use the `thumbnailUrl` computed param.
    public var thumbnailPath: String?

    /// The game description.
    public var description: String

    /// The year this game was published.
    public var yearPublished: Int

    /// The minimum number of players supported by this game.
    public var minPlayers: Int

    /// The maximum number of players supported by this game.
    public var maxPlayers: Int

    /// The playing time for this game.
    public var playingTime: Int

    /// The minimum playing time for this game.
    public var minPlaytime: Int

    /// The maximum playing time for this game.
    public var maxPlaytime: Int

    /// The minimum player age recommended for this game.
    public var minAge: Int

    /// A poll for the suggested number of players that this game will play well with.
    public var suggestedPlayers: SuggestedPlayersPoll

    /// A poll for the suggested minimum player age for this game.
    public var suggestedPlayerage: SuggestedPlayeragePoll

    /// A poll for the language dependence of this game.
    public var languageDependence: LanguageDependencePoll

    /// Links this game has to other site elements (publishers, designers, expansions, families, mechanics, etc...)
    public var links: [BoardGameLink]

    /// Statistics for this game. 
    /// - Note: Not present when `stats` is `false` in the API request.
    public var stats: Statistics?

    // - Mark: Computed Parameters

    /// The name that this game should be sorted on. For example, "The Gallerist" with a `sortIndex` of 5
    /// will be sorted simply as "Gallerist".
    public var sortName: String {
        get { return name.getSortString(sortIndex) }
    }

    /// The `NSURL` to retrieve the game's image.
    /// - Note: Nil if the game has no `imagePath`, or if `imagePath` is malformed.
    public var imageUrl: NSURL? {
        get { return NSURL(fromBggUrlString: imagePath) }
    }

    /// The `NSURL` to retrieve the game's thumbnail-sized image.
    /// - Note: Nil if the game has no `thumbnailPath`, or if `thumbnailPath` is malformed.
    public var thumbnailUrl: NSURL? {
        get { return NSURL(fromBggUrlString: thumbnailPath) }
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
    public var type: String

    /// A unique identifier for the value of this link
    public var id: Int

    /// The human-readable value for this link (e.g. if `type` is "boardgamemechanic",
    /// then `value` might be "Set Collection")
    public var value: String

    /// Whether this link is in-bound from another game. Commonly seen when this item
    /// is an expansion for another game.
    public var inbound: Bool?
}

// - Mark: SuggestedPlayersPoll

/**
 * A user-poll for the suggested number of players. Contains information on Recommended and Best
 * player counts.
 */
public struct SuggestedPlayersPoll {

    /// The total number of votes in the poll.
    public var totalVotes: Int

    /// A `dictionary` mapping the poll results to the number of players. This is mapped by string, rather
    /// than an integer, because the polls include things like "4+" meaning "more than 4"
    public var results: [String: [PollResult]]?
}

// - Mark: SuggestedPlayeragePoll

/**
 * A user poll for the suggested minimum player age for this game.
 */
public struct SuggestedPlayeragePoll {

    /// The total number of votes in the poll.
    public var totalVotes: Int

    /// A collection of poll results. `nil` if no one has participated in the poll.
    public var results: [PollResult]?
}

// - Mark: LanguageDependencePoll

/**
 * A user poll for the language dependence of this game.
 */
public struct LanguageDependencePoll {

    /// The total number of votes in the poll.
    public var totalVotes: Int

    /// A collection of poll results. `nil` if no one has participated in the poll.
    public var results: [PollResult]?
}

// - Mark: PollResult

/**
 * A result in a poll.
 */
public struct PollResult {

    /// The 'level' for this result. Appears to only be present in a Language Dependence poll.
    /// A '1' implies that the game is not language dependent, a '5' implies it's very dependent.
    public var level: Int?

    /// The value of the result. This is a human-readable string and will depend on the poll type.
    public var value: String

    /// The number of votes for this particular result.
    public var numVotes: Int
}

// - Mark: Statistics

/**
 * The site's recorded statistics for a game, if the game is retrieved from the API with `stats` set
 */
public struct Statistics {

    /// The number of users who have rated this game.
    public var usersRated: Int

    /// The average rating given to this game.
    public var average: Double

    /// The bayesian (weighted) average rating for this game. Also known as the "GeekRating"
    public var bayesAverage: Double

    /// The standard deviation in ratings for this game.
    public var stdDev: Double

    /// The median rating for this game.
    /// - Note: Currently the site appears to always return `0` for this value.
    public var median: Double

    /// The number of users that have marked this game as owned.
    public var owned: Int

    /// The number of users that have this game for trade.
    public var trading: Int

    /// The number of users that have marked this game as one they would like to receive in a trade.
    public var wanting: Int

    /// The number of users that have added this game to their wishlist.
    public var wishing: Int

    /// The number of user comments on this game.
    public var numComments: Int

    /// The number of users who have submitted a "weight" for this game.
    public var numWeights: Int

    /// The average "weight" of this game, submitted by users. Ratings are on a scale of 1-5,
    /// with 1 being the easiest to understand.
    public var averageWeight: Double

    /// An array of ranks for this game, indicating its position on various lists.
    public var ranks: [GameRank]
}

/**
 *  A structure to hold the information about a game's ranking within a particular family. Common
 *  to both games retrieved from the collection url (with `stats` enabled) as well as the thing url.
 */
public struct GameRank {

    /// The category of the ranking. Appears to be either "subtype" or "family"
    public var type: String

    /// The id of the family the game is ranked in.
    /// Will be 1 for the "boardgame" rank, and other numbers for other ranks (e.g. "thematicgames", "familygames")
    public var id: Int

    /// The name of the family the game is ranked in.
    public var name: String

    /// The friendly name of the family the game is ranked in.
    public var friendlyName: String

    /// The ranking of the game in this family. 0 if unranked.
    public var value: Int

    /// The weighted average for the rating of the game within this family.
    public var bayesAverage: Double
}