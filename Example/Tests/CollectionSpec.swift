//
// Created by Geoffrey Amey on 4/15/16.
// Copyright (c) 2016 Geoffrey Amey. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SWXMLHash
import OHHTTPStubs

@testable import GABoardGameGeek

class CollectionSpec: QuickSpec {

    override func spec() {

        describe("A Collection API Request") {

            context("for a standard list") {

                it("should contain standard fields, and not optional ones") {
                    var apiResult: ApiResult<[CollectionBoardGame]>?

                    waitUntil() { done in
                        GABoardGameGeek().getUserCollection("test", brief: false, stats: false) { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beTrue())
                    expect(apiResult?.value).to(haveCount(4))

                    let game = apiResult?.value?[0] // Castles of Burgundy

                    expect(game).toNot(beNil())

                    if(game != nil) {
                        expect(game!.objectId).to(equal(84876))
                        expect(game!.name).to(equal("The Castles of Burgundy"))
                        expect(game!.sortName).to(equal("Castles of Burgundy"))
                        expect(game!.yearPublished).to(equal(2011))
                        expect(game!.collId).to(equal(29577003))

                        expect(game!.status.owned).to(beTrue())
                        expect(game!.status.prevOwned).to(beFalse())
                        expect(game!.status.forTrade).to(beFalse())
                        expect(game!.status.wantInTrade).to(beFalse())
                        expect(game!.status.wantToPlay).to(beFalse())
                        expect(game!.status.wantToBuy).to(beFalse())
                        expect(game!.status.wishList).to(beFalse())
                        expect(game!.status.preOrdered).to(beFalse())
                        expect(game!.status.wishListPriority).to(beNil())

                        expect(game!.imagePath).to(equal("//cf.geekdo-images.com/images/pic1176894.jpg"))
                        expect(game!.imageUrl).toNot(beNil())
                        expect(game!.imageUrl!.absoluteString).to(equal("https://cf.geekdo-images.com/images/pic1176894.jpg"))

                        expect(game!.thumbnailPath).to(equal("//cf.geekdo-images.com/images/pic1176894_t.jpg"))
                        expect(game!.thumbnailUrl).toNot(beNil())
                        expect(game!.thumbnailUrl!.absoluteString).to(equal("https://cf.geekdo-images.com/images/pic1176894_t.jpg"))

                        expect(game!.numPlays).to(equal(6))

                        // The following fields should be nil for this game
                        expect(game!.comment).to(beNil())
                        expect(game!.wishListComment).to(beNil())
                        expect(game!.stats).to(beNil())
                    }
                }
            } // context( for a standard list )

            context("for a brief list") {

                it("should contain only the base fields") {
                    var apiResult: ApiResult<[CollectionBoardGame]>?

                    waitUntil() { done in
                        GABoardGameGeek().getUserCollection("test", brief: true, stats: false) { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beTrue())
                    expect(apiResult?.value).to(haveCount(4))

                    let game = apiResult?.value?[3] // Zooloretto

                    expect(game).toNot(beNil())

                    if(game != nil) {
                        expect(game!.objectId).to(equal(27588))
                        expect(game!.name).to(equal("Zooloretto"))
                        expect(game!.sortName).to(equal("Zooloretto"))
                        expect(game!.collId).to(equal(29622796))

                        expect(game!.yearPublished).to(beNil())

                        expect(game!.status.owned).to(beFalse())
                        expect(game!.status.prevOwned).to(beFalse())
                        expect(game!.status.forTrade).to(beFalse())
                        expect(game!.status.wantInTrade).to(beFalse())
                        expect(game!.status.wantToPlay).to(beFalse())
                        expect(game!.status.wantToBuy).to(beFalse())
                        expect(game!.status.wishList).to(beTrue())
                        expect(game!.status.preOrdered).to(beFalse())
                        expect(game!.status.wishListPriority).to(equal(3))


                        expect(game!.imagePath).to(beNil())
                        expect(game!.imageUrl).to(beNil())
                        expect(game!.thumbnailPath).to(beNil())
                        expect(game!.thumbnailUrl).to(beNil())
                        expect(game!.numPlays).to(beNil())
                        expect(game!.comment).to(beNil())
                        expect(game!.wishListComment).to(beNil())
                        expect(game!.stats).to(beNil())
                    }
                }
            } // context( for a brief list )

            context("for a standard list with stats") {

                it("should contain all of the fields including statisics") {
                    var apiResult: ApiResult<[CollectionBoardGame]>?

                    waitUntil() { done in
                        GABoardGameGeek().getUserCollection("test", brief: false, stats: true) { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beTrue())
                    expect(apiResult?.value).to(haveCount(4))

                    let game = apiResult?.value?[2] // Star Wars: Imperial Assault

                    expect(game).toNot(beNil())

                    if( game != nil ) {
                        expect(game!.objectId).to(equal(164153))
                        expect(game!.name).to(equal("Star Wars: Imperial Assault"))
                        expect(game!.sortName).to(equal("Star Wars: Imperial Assault"))
                        expect(game!.collId).to(equal(28295925))

                        expect(game!.yearPublished).to(equal(2014))

                        expect(game!.status.owned).to(beTrue())
                        expect(game!.status.prevOwned).to(beFalse())
                        expect(game!.status.forTrade).to(beFalse())
                        expect(game!.status.wantInTrade).to(beFalse())
                        expect(game!.status.wantToPlay).to(beFalse())
                        expect(game!.status.wantToBuy).to(beFalse())
                        expect(game!.status.wishList).to(beFalse())
                        expect(game!.status.preOrdered).to(beFalse())
                        expect(game!.status.wishListPriority).to(beNil())

                        expect(game!.imagePath).to(equal("//cf.geekdo-images.com/images/pic2247647.jpg"))
                        expect(game!.imageUrl).toNot(beNil())
                        expect(game!.imageUrl!.absoluteString).to(equal("https://cf.geekdo-images.com/images/pic2247647.jpg"))

                        expect(game!.thumbnailPath).to(equal("//cf.geekdo-images.com/images/pic2247647_t.jpg"))
                        expect(game!.thumbnailUrl).toNot(beNil())
                        expect(game!.thumbnailUrl!.absoluteString).to(equal("https://cf.geekdo-images.com/images/pic2247647_t.jpg"))

                        expect(game!.numPlays).to(equal(9))

                        expect(game!.comment).to(beNil())
                        expect(game!.wishListComment).to(equal("Star Wars D&D."))

                        expect(game!.stats).toNot(beNil())
                        let stats = game!.stats!
                        expect(stats.minPlayers).to(equal(2))
                        expect(stats.maxPlayers).to(equal(5))
                        expect(stats.minPlaytime).to(equal(60))
                        expect(stats.maxPlaytime).to(equal(120))
                        expect(stats.playingTime).to(equal(120))
                        expect(stats.numOwned).to(equal(13637))
                        
                        expect(stats.rating.userRating).to(beCloseTo(9.0))
                        expect(stats.rating.averageRating).to(beCloseTo(8.29618))
                        expect(stats.rating.bayesAverageRating).to(beCloseTo(7.94556))
                    }

                }
            } // context( for a standard list with stats )

            context("for a brief list with stats") {

                it("should contain all of the fields including statisics") {
                    var apiResult: ApiResult<[CollectionBoardGame]>?

                    waitUntil() { done in
                        GABoardGameGeek().getUserCollection("test", brief: true, stats: true) { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beTrue())

                    let game = apiResult?.value?[1] // Memoir '44

                    expect(game).toNot(beNil())

                    if(game != nil) {
                        expect(game!.objectId).to(equal(10630))
                        expect(game!.name).to(equal("Memoir '44"))
                        expect(game!.sortName).to(equal("Memoir '44"))
                        expect(game!.collId).to(equal(28226243))

                        expect(game!.yearPublished).to(beNil())

                        expect(game!.status.owned).to(beTrue())
                        expect(game!.status.prevOwned).to(beFalse())
                        expect(game!.status.forTrade).to(beTrue())
                        expect(game!.status.wantInTrade).to(beFalse())
                        expect(game!.status.wantToPlay).to(beFalse())
                        expect(game!.status.wantToBuy).to(beFalse())
                        expect(game!.status.wishList).to(beFalse())
                        expect(game!.status.preOrdered).to(beFalse())
                        expect(game!.status.wishListPriority).to(beNil())

                        expect(game!.imagePath).to(beNil())
                        expect(game!.imageUrl).to(beNil())
                        expect(game!.thumbnailPath).to(beNil())
                        expect(game!.thumbnailUrl).to(beNil())

                        expect(game!.numPlays).to(beNil())

                        expect(game!.comment).to(beNil())
                        expect(game!.wishListComment).to(beNil())

                        expect(game!.stats).toNot(beNil())
                        let stats = game!.stats!
                        expect(stats.minPlayers).to(equal(2))
                        expect(stats.maxPlayers).to(equal(2))
                        expect(stats.minPlaytime).to(equal(30))
                        expect(stats.maxPlaytime).to(equal(60))
                        expect(stats.playingTime).to(equal(60))
                        expect(stats.numOwned).to(equal(21504))
                        
                        expect(stats.rating.userRating).to(beCloseTo(8.0))
                        expect(stats.rating.averageRating).to(beCloseTo(7.52372))
                        expect(stats.rating.bayesAverageRating).to(beCloseTo(7.39571))
                    }
                    
                }
            } // context( for a brief list with stats )

            context("for a request with a timeout") {
                var apiResult: ApiResult<[CollectionBoardGame]>?

                beforeEach {
                    apiResult = nil
                }

                it("should timeout if a request is too short") {
                    waitUntil(timeout: 10) { done in
                        GABoardGameGeek().getUserCollection("delay", timeoutSeconds: 3) { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isFailure).to(beTrue())
                    expect(apiResult?.error).to(equal(BggError.serverNotReady))
                }

                it("should return a real result given enough time") {
                    waitUntil(timeout: 10) { done in
                        GABoardGameGeek().getUserCollection("delay", timeoutSeconds: 7) { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beTrue())
                    expect(apiResult?.value).to(haveCount(0))
                }

            } // context( for a request with a timeout )

            context("for an invalid username") {

                it("should return an ApiError") {
                    var apiResult: ApiResult<[CollectionBoardGame]>?

                    waitUntil(timeout: 10) { done in
                        GABoardGameGeek().getUserCollection("invalid") { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isFailure).to(beTrue())
                    expect(apiResult?.error).to(equal(BggError.apiError("Invalid username specified")))
                }
            } // context( for an invalid username )

            context("for an empty collection") {
                it("should return a collection of 0 elements") {
                    var apiResult: ApiResult<[CollectionBoardGame]>?

                    waitUntil(timeout: 10) { done in
                        GABoardGameGeek().getUserCollection("empty") { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beTrue())
                    expect(apiResult?.value).to(haveCount(0))
                }
            } // context( for an empty collection )

            context("with invalid XML elements") {
                var parser: XMLIndexer?
                let xml =
                    "<root>" +
                    "    <item objecttype=\"thing\" objectid=\"444\" subtype=\"boardgame\" collid=\"44\">" +
                    //"        <name sortindex=\"1\">Error</name>" +
                    "        <status own=\"1\" prevowned=\"0\" fortrade=\"1\" want=\"0\" wanttoplay=\"0\" wanttobuy=\"0\" wishlist=\"0\" preordered=\"0\" lastmodified=\"2016-04-04 20:19:37\"/>" +
                    "    </item>" +

                    //"    <status own=\"1\" prevowned=\"0\" fortrade=\"1\" want=\"0\" wanttoplay=\"0\" wanttobuy=\"0\" wishlist=\"0\" preordered=\"0\" lastmodified=\"2016-04-04 20:19:37\"/>" +
                    "    <status prevowned=\"0\" fortrade=\"1\" want=\"0\" wanttoplay=\"0\" wanttobuy=\"0\" wishlist=\"0\" preordered=\"0\" lastmodified=\"2016-04-04 20:19:37\"/>" +

                    //"    <stats minplayers=\"1\" maxplayers=\"2\" minplaytime=\"20\" maxplaytime=\"60\" playingtime=\"45\" numowned=\"4444\">" +
                    "    <stats minplayers=\"1\" maxplayers=\"2\" minplaytime=\"20\" maxplaytime=\"60\" playingtime=\"45\">" +
                    "        <rating value=\"N/A\">" +
                    "            <average value=\"7.66143\"/>" +
                    "            <bayesaverage value=\"5.68734\"/>" +
                    "        </rating>" +
                    "    </stats>" +

                    "    <rating value=\"N/A\">" +
                    //"        <average value=\"7.66143\"/>" +
                    "        <bayesaverage value=\"5.68734\"/>" +
                    "    </rating>" +

                    //"    <rank type=\"subtype\" id=\"1\" name=\"boardgame\" friendlyname=\"Board Game Rank\" value=\"3785\" bayesaverage=\"5.68734\"/>" +
                    "    <rank id=\"1\" name=\"boardgame\" friendlyname=\"Board Game Rank\" value=\"3785\" bayesaverage=\"5.68734\"/>" +
                    "</root>"

                beforeEach {
                    parser = SWXMLHash.parse(xml)
                }

                it("should fail if a game has no name element") {
                    expect{ try (parser!["root"]["item"].value() as CollectionBoardGame) }.to(throwError(errorType: XMLDeserializationError.self))
                }

                it("should fail if a status block is missing an element") {
                    expect{ try (parser!["root"]["status"].value() as CollectionStatus) }.to(throwError(errorType: XMLDeserializationError.self))
                }

                it("should fail if a stats block is missing an element") {
                    expect{ try parser!["root"]["stats"].value() as CollectionStats }.to(throwError(errorType: XMLDeserializationError.self))
                }

                it("should fail if a rating block is missing an element") {
                    expect{ try parser!["root"]["rating"].value() as CollectionRating }.to(throwError(errorType: XMLDeserializationError.self))
                }

                it("should fail if a rank block is missing an element") {
                    expect{ try parser!["root"]["rank"].value() as GameRank }.to(throwError(errorType: XMLDeserializationError.self))
                }

            }
        }

        beforeSuite {

            var retryCount = 0

            stub(condition: isHost("boardgamegeek.com") && containsQueryParams(["username": "test", "brief":"0", "stats":"0"])) { _ in
                let stubPath = OHPathForFile("TestData/collection.xml", type(of: self))
                return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200, headers: ["Content-Type":"text/xml"])
            }
            stub(condition: isHost("boardgamegeek.com") && containsQueryParams(["username": "test", "brief":"1", "stats":"0"])) { _ in
                let stubPath = OHPathForFile("TestData/collection_brief.xml", type(of: self))
                return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200, headers: ["Content-Type":"text/xml"])
            }
            stub(condition: isHost("boardgamegeek.com") && containsQueryParams(["username": "test", "brief":"0", "stats":"1"])) { _ in
                let stubPath = OHPathForFile("TestData/collection_stats.xml", type(of: self))
                return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200, headers: ["Content-Type":"text/xml"])
            }
            stub(condition: isHost("boardgamegeek.com") && containsQueryParams(["username": "test", "brief":"1", "stats":"1"])) { _ in
                let stubPath = OHPathForFile("TestData/collection_brief_stats.xml", type(of: self))
                return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200, headers: ["Content-Type":"text/xml"])
            }
            stub(condition: isHost("boardgamegeek.com") && containsQueryParams(["username": "invalid"])) { _ in
                let stubPath = OHPathForFile("TestData/collection_invalid_username.xml", type(of: self))
                return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200, headers: ["Content-Type":"text/xml"])
            }
            stub(condition: isHost("boardgamegeek.com") && containsQueryParams(["username": "empty"])) { _ in
                let stubPath = OHPathForFile("TestData/collection_empty.xml", type(of: self))
                return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200, headers: ["Content-Type":"text/xml"])
            }
            stub(condition: isHost("boardgamegeek.com") && containsQueryParams(["username": "delay"])) { _ in
                let stubPathValid = OHPathForFile("TestData/collection_empty.xml", type(of: self))
                let stubPathNotReady = OHPathForFile("TestData/collection_notready.xml", type(of: self))

                retryCount += 1
                if retryCount <= 6 {
                    return OHHTTPStubsResponse(fileAtPath: stubPathNotReady!, statusCode: 202, headers: ["Content-Type":"text/xml"])
                } else {
                    return OHHTTPStubsResponse(fileAtPath: stubPathValid!, statusCode: 200, headers: ["Content-Type":"text/xml"])
                }
            }
        }

        afterSuite {
            // Clear out the HTTP Stubs
            OHHTTPStubs.removeAllStubs()
        }
    }
}
