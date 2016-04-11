//
//  XmlDeserializers.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/6/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation
import SWXMLHash

extension CollectionBoardGame: XMLIndexerDeserializable {

    /**
     Deserializes an "item" element in a BoardGameGeek "collection" response. This item represents
     a "CollectionBoardGame", and contains a number of required and several optional fields.
     
     The format of the item element is as follows:
     <item objecttype="thing" objectid="177590" subtype="boardgame" collid="29096777">
        <name sortindex="1">13 Days: The Cuban Missile Crisis</name>
        <yearpublished>2015</yearpublished>
        <image>//cf.geekdo-images.com/images/pic2935653.jpg</image>
        <thumbnail>//cf.geekdo-images.com/images/pic2935653_t.jpg</thumbnail>
        <stats minplayers="2" maxplayers="2" minplaytime="40" maxplaytime="60" playingtime="60" numowned="238">
           <rating value="N/A">
              <usersrated value="70"/>
              <average value="7.66143"/>
              <bayesaverage value="5.68734"/>
              <stddev value="0.795755"/>
              <median value="0"/>
              <ranks>
                 <rank type="subtype" id="1" name="boardgame" friendlyname="Board Game Rank" value="3785" bayesaverage="5.68734"/>
              </ranks>
           </rating>
        </stats>
        <status own="1" prevowned="0" fortrade="0" want="0" wanttoplay="0" wanttobuy="0" wishlist="0" preordered="0" lastmodified="2016-04-04 20:19:37"/>
        <numplays>1</numplays>
     </item>

     - parameter node: An XMLIndexer indexed to an "item" tag representing a CollectionBoardGame

     - throws: XMLDeserializationError if there is a problem with the deserialization.

     - returns: A CollectionBoardGame structure.
     */
    public static func deserialize(node: XMLIndexer) throws -> CollectionBoardGame {
        guard let objectIdStr = node.element?.attributes["objectid"],
            let sortIndexStr = node["name"].element?.attributes["sortindex"]
                else { throw XMLDeserializationError.NodeIsInvalid(node: node)
        }

        guard let objectId = Int(objectIdStr), let sortIndex = Int(sortIndexStr)
            else { throw XMLDeserializationError.NodeIsInvalid(node: node)
        }

        return try CollectionBoardGame(
            objectId: objectId,
            name: node["name"].value(),
            sortIndex: sortIndex,
            status: node["status"].value(),
            stats: node["stats"].value(),
            yearPublished: node["yearpublished"].value(),
            imagePath: node["image"].value(),
            thumbnailPath: node["thumbnail"].value(),
            numPlays: node["numplays"].value(),
            wishListComment: (node["wishlistcomment"].value() as String?)?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            comment: (node["comment"].value() as String?)?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        )
    }
}

extension CollectionStatus: XMLIndexerDeserializable {

    /**
     Deserializes a "status" indexer in BoardGameGeek "collection" response.

     The format of the status element is as follows:
     <status own="0" prevowned="0" fortrade="0" want="0" wanttoplay="1" wanttobuy="0" wishlist="1" wishlistpriority="3" preordered="0" lastmodified="2015-12-18 09:38:29" />

     - parameter node: The XMLIndexer status node

     - throws: XMLDeserializationError.NodeIsInvalid if the node does not contain all of the required attributes.

     - returns: A CollectionStatus structure.
     */
    public static func deserialize(node: XMLIndexer) throws -> CollectionStatus {
        guard let owned = node.element?.attributes["own"],
            let prevOwned = node.element?.attributes["prevowned"],
            let wantToBuy = node.element?.attributes["wanttobuy"],
            let wantToPlay = node.element?.attributes["wanttoplay"],
            let preOrdered = node.element?.attributes["preordered"],
            let wantInTrade = node.element?.attributes["want"],
            let forTrade = node.element?.attributes["fortrade"],
            let wishList = node.element?.attributes["wishlist"],
            let lastModified = node.element?.attributes["lastmodified"]
                else { throw XMLDeserializationError.NodeIsInvalid(node: node)
        }

        var wishListPriority: Int?

        // Wish List Priority is only there if the item is on the wishlist.
        if let wishListPriorityStr = node.element?.attributes["wishlistpriority"] {
            wishListPriority = Int(wishListPriorityStr)
        }

        return CollectionStatus(
            owned: owned == "1",
            prevOwned: prevOwned == "1",
            wantToBuy: wantToBuy == "1",
            wantToPlay: wantToPlay == "1",
            preOrdered: preOrdered == "1",
            wantInTrade: wantInTrade == "1",
            forTrade: forTrade == "1",
            wishList: wishList == "1",
            wishListPriority: wishListPriority,
            lastModified: lastModified)
    }
}


extension CollectionStats: XMLIndexerDeserializable {

    /**
     Deserializes a "stats" indexer in BoardGameGeek "collection" response.

     The format of the stats element is as follows:
     <stats minplayers="2" maxplayers="2" minplaytime="40" maxplaytime="60" playingtime="60" numowned="253">
        <rating value="N/A">
            ...snip...
        </rating>
     </stats>
     
     - parameter node: The XMLIndexer stats node

     - throws: XMLDeserializationError.NodeIsInvalid if the node does not contain all of the required attributes.

     - returns: A CollectionStats structure.
     */
    public static func deserialize(node: XMLIndexer) throws -> CollectionStats {
        guard let minPlayersStr = node.element?.attributes["minplayers"],
            let maxPlayersStr = node.element?.attributes["maxplayers"],
            let minPlaytimeStr = node.element?.attributes["minplaytime"],
            let maxPlaytimeStr = node.element?.attributes["maxplaytime"],
            let playingTimeStr = node.element?.attributes["playingtime"],
            let numOwnedStr = node.element?.attributes["numowned"]
                else {
                    throw XMLDeserializationError.NodeIsInvalid(node: node)
        }

        guard let minPlayers = Int(minPlayersStr),
            let maxPlayers = Int(maxPlayersStr),
            let minPlaytime = Int(minPlaytimeStr),
            let maxPlaytime = Int(maxPlaytimeStr),
            let playingTime = Int(playingTimeStr),
            let numOwned = Int(numOwnedStr)
                else {
                    throw XMLDeserializationError.NodeIsInvalid(node: node)
        }

        return try CollectionStats(
            minPlayers: minPlayers,
            maxPlayers: maxPlayers,
            minPlaytime: minPlaytime,
            maxPlaytime: maxPlaytime,
            playingTime: playingTime,
            numOwned: numOwned,
            rating: node["rating"].value()
        )
    }
}

extension CollectionRating: XMLIndexerDeserializable {

    /**
     Deserializes a "rating" indexer in BoardGameGeek "collection" response.

     The format of the rating element is as follows:
     <rating value="N/A">
        <usersrated value="70"/>
        <average value="7.66143"/>
        <bayesaverage value="5.68734"/>
        <stddev value="0.795755"/>
        <median value="0"/>
        <ranks>
            <rank ...snip... />
        </ranks>
     </rating>
     
     or 
     
     <rating value="7.5">
         <average value="7.66143"/>
         <bayesaverage value="5.68734"/>
     </rating>


     - parameter node: The XMLIndexer rating node

     - throws: XMLDeserializationError.NodeIsInvalid if the node does not contain all of the required attributes.

     - returns: A CollectionStats structure.
     */
    public static func deserialize(node: XMLIndexer) throws -> CollectionRating {
        guard let userRatingStr = node.element?.attributes["value"],
            let averageRatingStr = node["average"].element?.attributes["value"],
            let bayesAverageRatingStr = node["bayesaverage"].element?.attributes["value"]
                else {
                    throw XMLDeserializationError.NodeIsInvalid(node: node)
        }

        guard let averageRating = Double(averageRatingStr),
            let bayesAverageRating = Double(bayesAverageRatingStr)
                else {
                    throw XMLDeserializationError.NodeIsInvalid(node: node)
        }

        var stdDev: Double? = nil
        if let stdDevStr = node["stddev"].element?.attributes["value"] {
            stdDev = Double(stdDevStr)
        }

        var median: Double? = nil
        if let medianStr = node["median"].element?.attributes["value"] {
            median = Double(medianStr)
        }

        var usersRated: Int? = nil
        if let usersRatedStr = node["usersrated"].element?.attributes["value"] {
            usersRated = Int(usersRatedStr)
        }

        return try CollectionRating(
            userRating: Double(userRatingStr),
            usersRated: usersRated,
            averageRating: averageRating,
            bayesAverageRating: bayesAverageRating,
            stdDev: stdDev,
            median: median,
            ranks: node["ranks"]["rank"].value()
        )
    }
}

extension GameRank: XMLElementDeserializable {

    /**
     Deserializes a "rating" element in BoardGameGeek "collection" response.

     The format of the rating element is as follows:
     <rank type="subtype" id="1" name="boardgame" friendlyname="Board Game Rank" value="3616" bayesaverage="5.70119"/>

     - parameter element: The `rank` element

     - throws: XMLDeserializationError.

     - returns: A populated GameRank structure
     */
    public static func deserialize(element: XMLElement) throws -> GameRank {
        guard let typeStr = element.attributes["type"],
            let idStr = element.attributes["id"],
            let nameStr = element.attributes["name"],
            let friendlyNameStr = element.attributes["friendlyname"],
            let valueStr = element.attributes["value"],
            let bayesAverageStr = element.attributes["bayesaverage"]
                else {
                    throw XMLDeserializationError.TypeConversionFailed(type: "GameRank", element: element)
        }

        guard let id = Int(idStr), value = Int(valueStr), bayesAverage = Double(bayesAverageStr)
            else {
                throw XMLDeserializationError.TypeConversionFailed(type: "GameRank", element: element)
        }

        return GameRank(
            type: typeStr,
            id: id,
            name: nameStr,
            friendlyName: friendlyNameStr,
            value: value,
            bayesAverage: bayesAverage)
    }
}
