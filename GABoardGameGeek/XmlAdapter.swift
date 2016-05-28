//
//  XmlAdapter.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 5/28/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

internal class XmlAdapter {

    // TODO: Get all XML Parsing and Error Handling code in a single place.
    
    /*
     private func parseXml<ParseType: XMLIndexerDeserializable>(xml: String, elementPath: [String]) -> ApiResult<[ParseType]> {

     }

     private func parseXml<ParseType: XMLIndexerDeserializable>(xml: String, elementPath: [String]) -> ApiResult<ParseType> {
     do {
     let parser = SWXMLHash.parse(xml)
     let parsedValue: ParseType = try parser["items"]["item"].value()

     //if(elementPath.count == 1) {
     //    let parsedVal: Value = try parser["item"].value()
     //} else if (elementPath.count == 2) {
     //    let parsedVal: Value = try parser[elementPath[0]][elementPath[1]].value()
     //} else {
     //    return .Failure(.ApiError("Invalid Element Path: \(elementPath)"))
     //}
     return .Success(parsedValue)

     } catch XMLDeserializationError.TypeConversionFailed(let type, let element) {
     return .Failure(.XmlError("Error Parsing XML Response to \(type): \(element)"))
     } catch {
     return .Failure(.ApiError("Unhandled API Error: \(error)"))
     }
     }
     */
}
