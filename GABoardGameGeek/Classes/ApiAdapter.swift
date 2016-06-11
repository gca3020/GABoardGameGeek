//
//  ApiAdapter.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 5/28/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Alamofire
import Foundation
import SWXMLHash

internal class ApiAdapter {

    /**
     Make an API request, and parse the results into a collection of objects. This function optionally
     takes a retryUntil param, which will cause the request to retry if the server indicates that it
     is available, but not ready yet (a 202 Status Code). This retry is necessary when querying a user
     collection.

     - parameter url:          The URL that we should request.
     - parameter params:       The parameters of the Collection Request, already encoded as a URL
     - parameter rootElement:  The root element name of the XML Element that this request should return
     - parameter childElement: The child element name of the XML Element that this request should return
     - parameter retryUntil:   The absolute end time after which we should stop retrying.
     - parameter closure:      The completion closure when we have either finished or failed
     */
    internal func request<T: XMLIndexerDeserializable>(url: String,
                                                       params: [String: String],
                                                       rootElement: String, childElement: String,
                                                       retryUntil: NSDate = NSDate(),
                                                       closure: ApiResult<[T]> -> ()) {
        // Make the raw request, and handle the result
        requestDataOnce(url, params: params) { result in
            switch(result) {
            case .Success(let xmlString):
                closure(self.parse(xmlString, rootElement: rootElement, childElement: childElement))
            case .Failure(let error):
                switch(error) {
                case .ServerNotReady:
                    // In some cases (collection requests), a 202 status code means we should try again,
                    // so queue up a retry to happen in one second, as long as we're still below the timeout.
                    if( (NSDate().compare(retryUntil) == NSComparisonResult.OrderedAscending) ) {
                        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
                        dispatch_after(delay, dispatch_get_main_queue()) {
                            self.request(url, params: params, rootElement: rootElement, childElement: childElement, retryUntil: retryUntil, closure: closure)
                        }
                    }
                    else {
                        closure(.Failure(error))
                    }
                default:
                    closure(.Failure(error))
                }
            }
        }
    }

    // MARK: - Networking

    /**
     Make an API request to the given URL with the specified parameters. The result
     is an asynchronous call to the supplied closure, taking an ApiResult.

     - parameter baseUrl: The base URL to make a call on. This does NOT include parameters
     - parameter params:  The parameters to make the call on. These should be URL Query Encoded already
     - parameter closure: The closure to call with the response
     */
    private func requestDataOnce(baseUrl: String, params: [String: String], closure: ApiResult<String> -> ()) {
        Alamofire.request(.GET, baseUrl, parameters: params)
            .validate(statusCode: 200...202)
            .validate(contentType: ["text/xml"])
            .responseString { response in
                switch response.result {
                case .Success:
                    if let statusCode = response.response?.statusCode {
                        if( statusCode == 202 ) {
                            closure(.Failure(.ServerNotReady))
                        } else {
                            closure(.Success(response.result.value!))
                        }
                    }
                case .Failure(let error):
                    closure(.Failure(.ConnectionError(error)))
                }
        }
    }

    // MARK: - XML Parsing

    /**
     A Generic Function to parse the XML returned from a network request into a collection
     of objects conforming to the XMLIndexerDeserializable protocol.

     - parameter xml:          The XML data to parse
     - parameter rootElement:  The root element, containing 0..n child elements
     - parameter childElement: The child elements, where each child element maps to a 'T'

     - returns: ApiResult.Success with an array of n objects of type 'T' or ApiResult.Failure
                with an appropriate Error
     */
    private func parse<T: XMLIndexerDeserializable>(xml: String, rootElement: String, childElement: String) -> ApiResult<[T]> {
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
