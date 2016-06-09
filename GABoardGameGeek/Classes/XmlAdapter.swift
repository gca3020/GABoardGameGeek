//
//  XmlAdapter.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 5/28/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation
import SWXMLHash

internal class XmlAdapter {

    /**
     A Generic Function to parse the XML returned from a network request into a collection
     of objects conforming to the XMLIndexerDeserializable protocol.

     - parameter xml:          The XML data to parse
     - parameter rootElement:  The root element, containing 0..n child elements
     - parameter childElement: The child elements, where each child element maps to a 'T'

     - returns: ApiResult.Success with an array of n objects of type 'T' or ApiResult.Failure
                with an appropriate Error
     */
    internal func parse<T: XMLIndexerDeserializable>(xml: String, rootElement: String, childElement: String) -> ApiResult<[T]> {
        var retVal = [T]()

        do {
            let xmlIndexer = SWXMLHash.parse(xml)

            // Check for errors before we attempt to parse out any actual data
            if let error = checkForApiError(xmlIndexer) {
                return .Failure(error)
            }

            // Try to parse the collection. We do it this way to handle the case where the rootElement
            // is empty and does not contain any of the child element
            for elem in xmlIndexer[rootElement][childElement] {
                retVal.append(try elem.value())
            }

            // If we have made it this far, it means we were successful, and can return the collection
            // we built
            return .Success(retVal)
        } catch {
            return .Failure(handleXmlError(error))
        }
    }

    /**
     Checks an XML Indexer for one of a handful of possible errors that it could return.

     - parameter indexer: The XMLIndexer to check for errors

     - returns: The ApiError if present, or nil if no errors were detected.
     */
    private func checkForApiError(indexer: XMLIndexer) -> BggError? {
        // For some calls, the error message will look like this:
        // <errors><error><message>MessageText</message></error></errors> block
        if let errorMessage = indexer["errors"]["error"]["message"].element?.text {
            return .ApiError(errorMessage)
        }

        // Occasionally, the XML contains just this:
        //<div class="messagebox error">error reading chunk of file</div>
        if let errorMessage = indexer["div"].element?.text {
            return .ApiError(errorMessage.trimWhitespace)
        }

        return nil
    }

    /**
     Handles the various types of errors that can occur during XML Parsing, wrapping them in
     an XmlError to be passed back to the user.

     - parameter error: The error type that we are handling

     - returns: The XML Error
     */
    private func handleXmlError(error: ErrorType) -> BggError {
        switch error {
        case XMLDeserializationError.NodeIsInvalid(let node):
            return .XmlError("Node Is Invalid: \(node)")
        case XMLDeserializationError.TypeConversionFailed(let type, let element):
            return .XmlError("Could Not Deserialize \(type): \(element)")
        default:
            return .XmlError("Unhandled Error: \(error)")
        }
    }
}
