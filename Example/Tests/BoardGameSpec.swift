//
// Created by Geoffrey Amey on 4/22/16.
// Copyright (c) 2016 Geoffrey Amey. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SWXMLHash
import OHHTTPStubs

@testable import GABoardGameGeek

class BoardGameSpec: QuickSpec {

    override func spec() {

        describe("A Game API Request") {

            context("for a single game") {

                it("should be avaiable without statistics") {
                    var apiResult: ApiResult<BoardGame>?

                    waitUntil() { done in
                        GABoardGameGeek().getGameById(161936) { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beTrue())
                    expect(apiResult?.isFailure).to(beFalse())
                    expect(apiResult?.value).toNot(beNil())
                    expect(apiResult?.error).to(beNil())

                    let game = apiResult?.value
                    expect(game).toNot(beNil())

                    expect(game!.objectId).to(equal(161936))
                    expect(game!.type).to(equal("boardgame"))

                    expect(game!.name).to(equal("Pandemic Legacy: Season 1"))
                    expect(game!.sortIndex).to(equal(1))
                    expect(game!.sortName).to(equal("Pandemic Legacy: Season 1"))

                    expect(game!.description.hasPrefix("Pandemic Legacy is a co-operative campaign game")).to(beTrue())

                    expect(game!.thumbnailPath).to(equal("//cf.geekdo-images.com/images/pic2452831_t.png"))
                    expect(game!.thumbnailUrl).toNot(beNil())
                    expect(game!.thumbnailUrl!.absoluteString).to(equal("http://cf.geekdo-images.com/images/pic2452831_t.png"))

                    expect(game!.imagePath).to(equal("//cf.geekdo-images.com/images/pic2452831.png"))
                    expect(game!.imageUrl).toNot(beNil())
                    expect(game!.imageUrl!.absoluteString).to(equal("http://cf.geekdo-images.com/images/pic2452831.png"))

                    expect(game!.yearPublished).to(equal(2015))
                    expect(game!.minPlayers).to(equal(2))
                    expect(game!.maxPlayers).to(equal(4))
                    expect(game!.minPlaytime).to(equal(60))
                    expect(game!.maxPlaytime).to(equal(60))
                    expect(game!.playingTime).to(equal(60))
                    expect(game!.minAge).to(equal(13))

                    expect(game!.suggestedPlayers.totalVotes).to(equal(211))
                    expect(game!.suggestedPlayers.results).toNot(beNil())
                    expect(game!.suggestedPlayers.results).to(haveCount(5))
                    expect(game!.suggestedPlayers.results!["4"]).to(haveCount(3))
                    expect(game!.suggestedPlayers.results!["4+"]).to(haveCount(3))
                    expect(game!.suggestedPlayers.results!["5"]).to(beNil())

                    expect(game!.suggestedPlayerage.totalVotes).to(equal(63))
                    expect(game!.suggestedPlayerage.results).toNot(beNil())
                    expect(game!.suggestedPlayerage.results).to(haveCount(12))

                    expect(game!.languageDependence.totalVotes).to(equal(64))
                    expect(game!.languageDependence.results).toNot(beNil())
                    expect(game!.languageDependence.results).to(haveCount(5))

                    expect(game!.links).to(haveCount(24))

                    expect(game!.links[0].type).to(equal("boardgamecategory"))
                    expect(game!.links[0].id).to(equal(1084))
                    expect(game!.links[0].value).to(equal("Environmental"))
                    expect(game!.links[0].inbound).to(beNil())

                    expect(game!.links[12].type).to(equal("boardgameimplementation"))
                    expect(game!.links[12].id).to(equal(30549))
                    expect(game!.links[12].value).to(equal("Pandemic"))
                    expect(game!.links[12].inbound).to(beTrue())

                    expect(game!.stats).to(beNil())
                }

                it("should be available with statistics") {
                    var apiResult: ApiResult<BoardGame>?

                    waitUntil() { done in
                        GABoardGameGeek().getGameById(161936, stats: true) { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beTrue())
                    expect(apiResult?.isFailure).to(beFalse())
                    expect(apiResult?.value).toNot(beNil())
                    expect(apiResult?.error).to(beNil())

                    let game = apiResult?.value
                    expect(game).toNot(beNil())
                    expect(game!.stats).toNot(beNil())
                    expect(game!.stats!.usersRated).to(equal(8969))
                    expect(game!.stats!.average).to(beCloseTo(8.6419))
                    expect(game!.stats!.bayesAverage).to(beCloseTo(8.3663))
                    expect(game!.stats!.stdDev).to(beCloseTo(1.9607))
                    expect(game!.stats!.median).to(beCloseTo(0.0))
                    expect(game!.stats!.owned).to(equal(14392))
                    expect(game!.stats!.trading).to(equal(31))
                    expect(game!.stats!.wanting).to(equal(545))
                    expect(game!.stats!.wishing).to(equal(4320))
                    expect(game!.stats!.numComments).to(equal(1641))
                    expect(game!.stats!.numWeights).to(equal(468))
                    expect(game!.stats!.averageWeight).to(beCloseTo(2.8034))

                    expect(game!.stats!.ranks).to(haveCount(3))
                    expect(game!.stats!.ranks[0].type).to(equal("subtype"))
                    expect(game!.stats!.ranks[0].id).to(equal(1))
                    expect(game!.stats!.ranks[0].name).to(equal("boardgame"))
                    expect(game!.stats!.ranks[0].friendlyName).to(equal("Board Game Rank"))
                    expect(game!.stats!.ranks[0].value).to(equal(1))
                    expect(game!.stats!.ranks[0].bayesAverage).to(beCloseTo(8.3663))

                    expect(game!.stats!.ranks[1].type).to(equal("family"))
                    expect(game!.stats!.ranks[1].id).to(equal(5496))
                    expect(game!.stats!.ranks[1].name).to(equal("thematic"))
                    expect(game!.stats!.ranks[1].friendlyName).to(equal("Thematic Rank"))
                    expect(game!.stats!.ranks[1].value).to(equal(1))
                    expect(game!.stats!.ranks[1].bayesAverage).to(beCloseTo(8.4309))

                    expect(game!.stats!.ranks[2].type).to(equal("family"))
                    expect(game!.stats!.ranks[2].id).to(equal(5497))
                    expect(game!.stats!.ranks[2].name).to(equal("strategygames"))
                    expect(game!.stats!.ranks[2].friendlyName).to(equal("Strategy Game Rank"))
                    expect(game!.stats!.ranks[2].value).to(equal(1))
                    expect(game!.stats!.ranks[2].bayesAverage).to(beCloseTo(8.3941))

                }
            } // context( for a single game )

            context("for multiple games") {

                it("contain all of the games requested") {
                    var apiResult: ApiResult<[BoardGame]>?

                    waitUntil() { done in
                        GABoardGameGeek().getGamesById([1,2,3,4,5]) { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beTrue())
                    expect(apiResult?.value).toNot(beNil())

                    expect(apiResult?.value).to(haveCount(5))

                    expect(apiResult?.value?[0].objectId).to(equal(1))
                    expect(apiResult?.value?[0].name).to(equal("Die Macher"))

                    expect(apiResult?.value?[1].objectId).to(equal(2))
                    expect(apiResult?.value?[1].name).to(equal("Dragonmaster"))

                    expect(apiResult?.value?[2].objectId).to(equal(3))
                    expect(apiResult?.value?[2].name).to(equal("Samurai"))

                    expect(apiResult?.value?[3].objectId).to(equal(4))
                    //expect(apiResult?.value?[3].name).to(equal("Tal der Könige")) TODO: This might be parsing wrong

                    expect(apiResult?.value?[4].objectId).to(equal(5))
                    expect(apiResult?.value?[4].name).to(equal("Acquire"))
                }
            } // context( for multiple games )

            context("for a broken game ID") {

                // NOTE: Some games (e.g. game 35) appear to return an error for some reason
                // in XMLAPI2. We should handle this somewhat gracefully
                it("should return an error") {
                    var apiResult: ApiResult<BoardGame>?

                    waitUntil() { done in
                        GABoardGameGeek().getGameById(35) { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isFailure).to(beTrue())
                    expect(apiResult?.error).to(equal(BggError.apiError("error reading chunk of file")))
                }
            } // context( for a broken game ID )

            context("for an invalid game ID") {

                it("should return an error when asking for a single game") {
                    var apiResult: ApiResult<BoardGame>?

                    waitUntil() { done in
                        GABoardGameGeek().getGameById(999999) { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isFailure).to(beTrue())
                    expect(apiResult?.isSuccess).to(beFalse())
                    expect(apiResult?.error).to(equal(BggError.apiError("Invalid Number of Items Returned: 0")))
                    expect(apiResult?.value).to(beNil())
                }

                it("should return an empty collection when asking for a collection") {
                    var apiResult: ApiResult<[BoardGame]>?

                    waitUntil() { done in
                        GABoardGameGeek().getGamesById([999999]) { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beTrue())
                    expect(apiResult?.value).to(haveCount(0))
                }
            } // context( for an invalid game ID )

            context("with network errors") {

                // These tests could be done for any request, but I'm only going to put them here.
                // Since all of the networking is common code anyway, I don't need to re-test it
                // every time.
                it("should timeout if the network does not respond") {
                    var apiResult: ApiResult<BoardGame>?

                    waitUntil() { done in
                        GABoardGameGeek().getGameById(0) { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beFalse())
                    expect(apiResult?.value).to(beNil())
                    expect(apiResult?.isFailure).to(beTrue())
                    //expect(apiResult?.error).to(equal(BggError.ConnectionError(NSError(domain: NSURLErrorDomain, code: -1009, userInfo: nil))))
                    expect(apiResult?.error).to(equal(BggError.connectionError))
                }
            }

            context("with an unparsable game") {
                it("should return an XML error if the site returns unparsable results") {
                    var apiResult: ApiResult<BoardGame>?

                    waitUntil() { done in
                        GABoardGameGeek().getGameById(34404) { result in
                            apiResult = result
                            done()
                        }
                    }

                    expect(apiResult).toNot(beNil())
                    expect(apiResult?.isSuccess).to(beFalse())
                    expect(apiResult?.value).to(beNil())
                    expect(apiResult?.isFailure).to(beTrue())
                    expect(apiResult?.error).to(matchError(BggError.xmlError("")))
                }
            }
        }

        beforeSuite {
            stub(condition: isHost("boardgamegeek.com") && containsQueryParams(["id": "161936", "stats": "0"])) { _ in
                let stubPath = OHPathForFile("TestData/thing.xml", type(of: self))
                return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200, headers: ["Content-Type":"text/xml"])
            }
            stub(condition: isHost("boardgamegeek.com") && containsQueryParams(["id": "161936", "stats": "1"])) { _ in
                let stubPath = OHPathForFile("TestData/thing_stats.xml", type(of: self))
                return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200, headers: ["Content-Type":"text/xml"])
            }
            stub(condition: isHost("boardgamegeek.com") && containsQueryParams(["id": "1,2,3,4,5"])) { _ in
                let stubPath = OHPathForFile("TestData/thing_multiple.xml", type(of: self))
                return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200, headers: ["Content-Type":"text/xml"])
            }
            stub(condition: isHost("boardgamegeek.com") && containsQueryParams(["id": "35"])) { _ in
                let stubPath = OHPathForFile("TestData/thing_error.xml", type(of: self))
                return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200, headers: ["Content-Type":"text/xml"])
            }
            stub(condition: isHost("boardgamegeek.com") && containsQueryParams(["id": "999999"])) { _ in
                let stubPath = OHPathForFile("TestData/thing_empty.xml", type(of: self))
                return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200, headers: ["Content-Type":"text/xml"])
            }
            stub(condition: isHost("boardgamegeek.com") && containsQueryParams(["id": "34404"])) { _ in
                let stubPath = OHPathForFile("TestData/thing_unparsable.xml", type(of: self))
                return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200, headers: ["Content-Type":"text/xml"])
            }
            stub(condition: isHost("boardgamegeek.com") && containsQueryParams(["id": "0"])) { _ in
                let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue), userInfo:nil)
                return OHHTTPStubsResponse(error:notConnectedError)
            }
        }

        afterSuite {
            // Clear out the HTTP Stubs
            OHHTTPStubs.removeAllStubs()
        }
    }
}
