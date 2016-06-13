//
//  SearchResult+Deserializers.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 6/12/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation
import SWXMLHash

extension SearchResult: XMLIndexerDeserializable {

    /**
     Deserializes an `<item>` element in a BoardGameGeek "search" response.

     The format of the element is as follows:
     ```xml
     <item type="boardgame" id="14780">
        <name type="primary" value="Brink"/>
        <yearpublished value="2004"/>
     </item>
     ```

     - parameter node: The `<item>` indexer

     - throws: `XMLDeserializationError`

     - returns: A `SearchResult` structure.
     */
    public static func deserialize(node: XMLIndexer) throws -> SearchResult {
        guard node.element != nil && node["name"].element != nil else {
            throw XMLDeserializationError.NodeIsInvalid(node: node)
        }

        do {
            return try SearchResult(
                itemType: node.element!.attribute("type"),
                objectId: node.element!.attribute("id"),
                nameType: node["name"].element!.attribute("type"),
                name: node["name"].element!.attribute("value"),
                yearPublished: node["yearpublished"].element?.attribute("value")
            )
        } catch {
            // If any errors occur while parsing this game, throw them as a single exception along
            // with the XML that the game deserializes from. This makes it much easier to track down
            // which particular field might be failing.
            throw XMLDeserializationError.TypeConversionFailed(type: "SearchResult", element: node.element!)
        }
    }
}
