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
    public static func deserialize(_ node: XMLIndexer) throws -> SearchResult {
        do {
            return try SearchResult(
                itemType: node.value(ofAttribute:"type"),
                objectId: node.value(ofAttribute:"id"),
                nameType: node["name"].value(ofAttribute:"type"),
                name: node["name"].value(ofAttribute:"value"),
                yearPublished: node["yearpublished"].value(ofAttribute:"value")
            )
        } catch {
            // If any errors occur while parsing this game, throw them as a single exception along
            // with the XML that the game deserializes from. This makes it much easier to track down
            // which particular field might be failing.
            throw XMLDeserializationError.TypeConversionFailed(type: "SearchResult", element: node.element!)
        }
    }
}
