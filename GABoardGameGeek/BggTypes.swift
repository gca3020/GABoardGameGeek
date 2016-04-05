//
//  BggTypes.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/3/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

/**
 * An enumeration to hold the results of making an API call into the BGG XMLAPI2
 *
 * - Success: The API operation was successful.
 * - ConnectionError: There were network connectivity issues. The Network or Server may be down.
 * - ServerError: We connected to the server, but it returned a non-200 HTTP Status Code (e.g. 404, 502)
 * - ApiError: Any error parsing the server response, or any other error that indicates a failure.
 *             This could be something like an invalid username, etc...
 */
public enum BggResult<Type>: ErrorType {
    case Success(result: Type)
    case ConnectionError(error: NSError)
    case ServerError(statusCode: Int)
    case ApiError(message: String)
}

/**
 *  A structure to hold the information about a game's rating. This struct contains the common
 *  information present in both a CollectionRating and an ItemRating
 */
public class BggStats {

    /// The BGG Average Rating for this game. If the game does not have enough ratings, it will be 0.0
    var averageRating = 0.0

    /// The BGG Weighted Average ("Geek Rating") for this game. If the game does not have enough ratings, it will be 0.0
    var bayesAverageRating = 0.0

    /// The number of users who own this game
    var numOwned = 0

    /// The standard deviation of this game's ratings. Not present when brief=1
    var stddev: Double?

    /// The median for a game's ratings? Seems to always be 0. Not present when brief=1
    var median: Int?

    ///  A collection of the game's rankings on various lists. Will be empty when brief=1
    var ranks = [BggRank]()
}

/**
 *  A structure to hold the information about a game's ranking within a particular family.
 */
public struct BggRank {

    /// The category of the ranking. Appears to be either "subtype" or "family"
    var type: String

    /// The id of the family the game is ranked in.
    /// Will be 1 for the "boardgame" rank, and other numbers for other ranks (e.g. thematicgames, familygames)
    var id: Int

    /// The name of the family the game is ranked in.
    var name: String

    /// The friendly name of the family the game is ranked in.
    var friendlyName: String

    /// The ranking of the game in this family. 0 if unranked.
    var value: Int

    /// The weighted average for the rating of the game within this family.
    var bayesAverage: Double
}