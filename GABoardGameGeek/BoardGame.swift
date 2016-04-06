//
//  BoardGame.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/3/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

/// A base class to represent a board game object. This contains the minimum amount of data that can be
/// returned from any query to BoardGameGeek.
public class BoardGame {

    // MARK: - Data Members

    /// The Object Id of this game
    let objectId: Int

    /// The name of the game.
    let name: String

    /// The charater the name should be sorted on (1-indexed)
    let sortIndex: Int

    // MARK: - Computed Parameters

    /// The sort-name of this game. A calculated parameter that indexes into the name by the sortIndex
    var sortName: String {
        get {
            if sortIndex > 0 && sortIndex <= name.characters.count {
                return name.substringFromIndex(name.startIndex.advancedBy(sortIndex-1))
            }
            else {
                return name
            }
        }
    }

    // MARK: - Initializers

    /**
     Initializer for a BoardGame

     - parameter objectId:  The game ID
     - parameter name:      The game name
     - parameter sortIndex: The character the name is sorted on (1-indexed)

     - returns: A BoardGame
     */
    init(objectId: Int, name: String, sortIndex: Int = 1) {
        self.objectId = objectId
        self.name = name
        self.sortIndex = sortIndex
    }
}

// MARK: - GameRank

/**
 *  A structure to hold the information about a game's ranking within a particular family. Common
 *  to both games retrieved from the collection url (with stats enabled) as well as the thing url.
 */
public struct GameRank {

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