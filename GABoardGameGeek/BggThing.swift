//
//  BggThing.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/3/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

public class BggThing {

    // MARK: - Data Members

    /// The object id of this thing.
    let objectId: Int

    /// The Name of the thing.
    let name: String

    /// The charater the name should be sorted on (1-indexed)
    let sortIndex: Int

    // MARK: - Computed Parameters

    /// The sort-name of this thing. A calculated parameter that indexes into the name by the sortIndex
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
     Initializer for a Thing

     - parameter objectId:  The Object ID
     - parameter name:      The Object Name
     - parameter sortIndex: The Character the name is sorted on (1-indexed)

     - returns: A BggThing
     */
    init(objectId: Int, name: String, sortIndex: Int = 1) {
        self.objectId = objectId
        self.name = name
        self.sortIndex = sortIndex
    }
}