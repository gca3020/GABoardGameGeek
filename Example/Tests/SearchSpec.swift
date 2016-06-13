//
// Created by Geoffrey Amey on 6/12/16.
// Copyright (c) 2016 Geoffrey Amey. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SWXMLHash
import OHHTTPStubs

@testable import GABoardGameGeek

class SearchSpec: QuickSpec {

    override func spec() {

        describe("A Search Request") {

            context("from an API Request") {

                it("should return search results") {
                    var apiResult: ApiResult<[SearchResult]>?
                    waitUntil() { done in
                        GABoardGameGeek().searchFor("pandemic") { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beTrue())

                    expect(apiResult?.value).to(haveCount(22))
                    expect(apiResult?.value?[3].itemType).to(equal("boardgame"))
                    expect(apiResult?.value?[3].objectId).to(equal(161936))
                    expect(apiResult?.value?[3].nameType).to(equal("primary"))
                    expect(apiResult?.value?[3].name).to(equal("Pandemic Legacy: Season 1"))
                    expect(apiResult?.value?[3].yearPublished).to(equal(2015))
                }

                it("should return an empty list if there are no results") {
                    var apiResult: ApiResult<[SearchResult]>?
                    waitUntil() { done in
                        GABoardGameGeek().searchFor("empty") { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beTrue())
                    expect(apiResult?.value).to(haveCount(0))
                }

                it("should allow you to specify the search type") {
                    var apiResult: ApiResult<[SearchResult]>?
                    waitUntil() { done in
                        GABoardGameGeek().searchFor("pandemic", searchType: "boardgameexpansion") { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beTrue())
                    expect(apiResult?.value).to(haveCount(4))
                }

                it("should allow you to specify an exact match") {
                    var apiResult: ApiResult<[SearchResult]>?
                    waitUntil() { done in
                        GABoardGameGeek().searchFor("pandemic", exactMatch: true) { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beTrue())
                    expect(apiResult?.value).to(haveCount(3))
                }



            } // context( from an API Request )

            context("with invalid XML elements") {
                var parser: XMLIndexer?
                let xml =
                "<root>" +
                "    <item type=\"boardgame\" id=\"57139\">" +
                //"        <name type=\"alternate\" value=\"Name\"/>" +
                "        <yearpublished value=\"2009\" />" +
                "    </item>" +

                //"    <item type=\"boardgame\" id=\"57139\">" +
                "    <notype id=\"57139\">" +
                "        <name type=\"alternate\" value=\"Name\"/>" +
                "        <yearpublished value=\"2009\" />" +
                "    </notype>" +

                "</root>"

                beforeEach {
                    parser = SWXMLHash.parse(xml)
                }

                it("should fail if a result has no name element") {
                    expect{ try (parser!["root"]["item"].value() as SearchResult) }.to(throwError(errorType: XMLDeserializationError.self))
                }

                it("should fail if a result has no type") {
                    expect{ try (parser!["root"]["notype"].value() as SearchResult) }.to(throwError(errorType: XMLDeserializationError.self))
                }

            } // context( with invalid xml elements )
        }

        beforeSuite {
            stub(isHost("boardgamegeek.com") && containsQueryParams(["query": "pandemic"])) { _ in
                let stubPath = OHPathForFile("TestData/search.xml", self.dynamicType)
                return fixture(stubPath!, headers: ["Content-Type":"text/xml"])
            }
            stub(isHost("boardgamegeek.com") && containsQueryParams(["query": "pandemic", "type": "boardgameexpansion"])) { _ in
                let stubPath = OHPathForFile("TestData/search_expansion.xml", self.dynamicType)
                return fixture(stubPath!, headers: ["Content-Type":"text/xml"])
            }
            stub(isHost("boardgamegeek.com") && containsQueryParams(["query": "pandemic", "exact": "1"])) { _ in
                let stubPath = OHPathForFile("TestData/search_exact.xml", self.dynamicType)
                return fixture(stubPath!, headers: ["Content-Type":"text/xml"])
            }
            stub(isHost("boardgamegeek.com") && containsQueryParams(["query": "empty"])) { _ in
                let stubPath = OHPathForFile("TestData/search_empty.xml", self.dynamicType)
                return fixture(stubPath!, headers: ["Content-Type":"text/xml"])
            }
        }

        afterSuite {
            // Clear out the HTTP Stubs
            OHHTTPStubs.removeAllStubs()
        }
    }
}
