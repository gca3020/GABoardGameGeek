//
//  CollectionBoardGame+Deserializers.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/6/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation
import SWXMLHash

extension CollectionBoardGame: XMLIndexerDeserializable {

    /**
     Deserializes an `<item>` element in a BoardGameGeek "collection" response. This element represents
     a `CollectionBoardGame`, and contains a number of required and several optional fields.
     
     The format of the item element is as follows:
     ```xml
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
     ```

     - parameter node: An `XMLIndexer` indexed to an `<item>` element representing a `CollectionBoardGame`

     - throws: `XMLDeserializationError` if there is a problem with the deserialization.

     - returns: A `CollectionBoardGame` structure.
     */
    public static func deserialize(_ node: XMLIndexer) throws -> CollectionBoardGame {
        guard node.element != nil && node["name"].element != nil else {
            throw XMLDeserializationError.NodeIsInvalid(node: node)
        }

        do {
            return try CollectionBoardGame(
                objectId: node.element!.attribute("objectid"),
                name: node["name"].value(),
                sortIndex: node["name"].element!.attribute("sortindex"),
                status: node["status"].value(),
                stats: node["stats"].value(),
                yearPublished: node["yearpublished"].value(),
                imagePath: node["image"].value(),
                thumbnailPath: node["thumbnail"].value(),
                numPlays: node["numplays"].value(),
                wishListComment: (node["wishlistcomment"].value() as String?)?.trimWhitespace,
                comment: (node["comment"].value() as String?)?.trimWhitespace
            )
        } catch {
            // If any errors occur while parsing this game, throw them as a single exception along
            // with the XML that the game deserializes from. This makes it much easier to track down
            // which particular field might be failing.
            throw XMLDeserializationError.TypeConversionFailed(type: "CollectionBoardGame", element: node.element!)
        }
    }
}

extension CollectionStatus: XMLElementDeserializable {

    /**
     Deserializes a `<status>` element in a BoardGameGeek "collection" response.

     The format of the status element is as follows:
     ```xml
     <status own="0" prevowned="0" fortrade="0" want="0" wanttoplay="1" wanttobuy="0" wishlist="1" wishlistpriority="3" preordered="0" lastmodified="2015-12-18 09:38:29" />
     ```

     - parameter node: The `<status>` element

     - throws: `XMLDeserializationError.NodeIsInvalid` if the node does not contain all of the required attributes.

     - returns: A `CollectionStatus` structure.
     */
    public static func deserialize(_ element: XMLElement) throws -> CollectionStatus {
        return try CollectionStatus(
            owned: element.attribute("own"),
            prevOwned: element.attribute("prevowned"),
            wantToBuy: element.attribute("wanttobuy"),
            wantToPlay: element.attribute("wanttoplay"),
            preOrdered: element.attribute("preordered"),
            wantInTrade: element.attribute("want"),
            forTrade: element.attribute("fortrade"),
            wishList: element.attribute("wishlist"),
            wishListPriority: element.attribute("wishlistpriority"),
            lastModified: element.attribute("lastmodified")
        )
    }
}


extension CollectionStats: XMLIndexerDeserializable {

    /**
     Deserializes a `<stats>` indexer in BoardGameGeek "collection" response.

     The format of the stats element is as follows:
     ```xml
     <stats minplayers="2" maxplayers="2" minplaytime="40" maxplaytime="60" playingtime="60" numowned="253">
        <rating value="N/A">
            ...snip...
        </rating>
     </stats>
     ```
     
     - parameter node: The `<stats>` indexer

     - throws: `XMLDeserializationError.NodeIsInvalid` if the node does not contain all of the required attributes.

     - returns: A `CollectionStats` structure.
     */
    public static func deserialize(_ node: XMLIndexer) throws -> CollectionStats {
        guard let element = node.element else {
            throw XMLDeserializationError.NodeIsInvalid(node: node)
        }

        return try CollectionStats(
            minPlayers: element.attribute("minplayers"),
            maxPlayers: element.attribute("maxplayers"),
            minPlaytime: element.attribute("minplaytime"),
            maxPlaytime: element.attribute("maxplaytime"),
            playingTime: element.attribute("playingtime"),
            numOwned: element.attribute("numowned"),
            rating: node["rating"].value()
        )
    }
}

extension CollectionRating: XMLIndexerDeserializable {

    /**
     Deserializes a "rating" indexer in BoardGameGeek "collection" response.

     The format of the rating element is as follows:
     ```xml
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
     ```
     
     or 
     ```xml
     <rating value="7.5">
         <average value="7.66143"/>
         <bayesaverage value="5.68734"/>
     </rating>
     ```

     - parameter node: The `<rating>` indexer

     - throws: `XMLDeserializationError.NodeIsInvalid` if the node does not contain all of the required attributes.

     - returns: A `CollectionStats` structure.
     */
    public static func deserialize(_ node: XMLIndexer) throws -> CollectionRating {
        guard node["average"].element != nil && node["bayesaverage"].element != nil else {
            throw XMLDeserializationError.NodeIsInvalid(node: node)
        }

        return try CollectionRating(
            userRating: node.element?.attribute("value"),
            usersRated: node["usersrated"].element?.attribute("value"),
            averageRating: node["average"].element!.attribute("value"),
            bayesAverageRating: node["bayesaverage"].element!.attribute("value"),
            stdDev: node["stddev"].element?.attribute("value"),
            median: node["median"].element?.attribute("value"),
            ranks: node["ranks"]["rank"].value()
        )
    }
}
