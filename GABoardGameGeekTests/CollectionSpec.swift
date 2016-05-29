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

        beforeSuite {
            // Stub out the HTTP requests that this suite will make
            stub(isHost("boardgamegeek.com") && containsQueryParams(["username": "test", "brief":"0", "stats":"0"])) { _ in
                let stubPath = OHPathForFile("TestData/collection.xml", self.dynamicType)
                return fixture(stubPath!, headers: ["Content-Type":"text/xml"])
            }
            stub(isHost("boardgamegeek.com") && containsQueryParams(["username": "test", "brief":"1", "stats":"0"])) { _ in
                let stubPath = OHPathForFile("TestData/collection_brief.xml", self.dynamicType)
                return fixture(stubPath!, headers: ["Content-Type":"text/xml"])
            }
            stub(isHost("boardgamegeek.com") && containsQueryParams(["username": "test", "brief":"0", "stats":"1"])) { _ in
                let stubPath = OHPathForFile("TestData/collection_stats.xml", self.dynamicType)
                return fixture(stubPath!, headers: ["Content-Type":"text/xml"])
            }
            stub(isHost("boardgamegeek.com") && containsQueryParams(["username": "test", "brief":"1", "stats":"1"])) { _ in
                let stubPath = OHPathForFile("TestData/collection_brief_stats.xml", self.dynamicType)
                return fixture(stubPath!, headers: ["Content-Type":"text/xml"])
            }
        }

        afterSuite {
            // Clear out the HTTP Stubs
            OHHTTPStubs.removeAllStubs()
        }

        describe("A Collection API Request") {
            var gameList = [CollectionBoardGame]()

            context("from a standard request") {

                beforeEach {
                    GABoardGameGeek().getUserCollection("test", brief: false, stats: true) { result in
                        switch(result) {
                        case .Success(let games):
                            gameList.appendContentsOf(games)
                            print(gameList)
                        case .Failure(let error):
                            print(error)
                        }
                    }
                }

                afterEach {
                    gameList.removeAll()
                }

                it("Should contain elements") {
                    expect(gameList).toEventually(haveCount(123))
                }
            }
        }

        describe("a collection board game") {
            var game: CollectionBoardGame?
            var parser: XMLIndexer?

            context("from a brief xml") {
                let xml =
                    "<item objecttype=\"thing\" objectid=\"111\" subtype=\"boardgame\" collid=\"11\">" +
                    "   <name sortindex=\"1\">Brief Game</name>" +
                    "   <status own=\"1\" prevowned=\"0\" fortrade=\"0\" want=\"0\" wanttoplay=\"0\" wanttobuy=\"0\" wishlist=\"0\"  preordered=\"0\" lastmodified=\"2016-04-04 20:19:37\" />"
                    "</item>"

                beforeEach {
                    parser = SWXMLHash.parse(xml)
                    game = try! parser!["item"].value()
                }

                it("should fully parse") {
                    expect(game).toNot(beNil())
                }

                it("should have an objectId") {
                    expect(game!.objectId).to(equal(111))
                }

                it("should have a name") {
                    expect(game!.name).to(equal("Brief Game"))
                    expect(game!.sortName).to(equal("Brief Game"))
                }

                it("should have a status block where only owned is true") {
                    expect(game!.status.owned).to(equal(true))
                    expect(game!.status.prevOwned).to(equal(false))
                    expect(game!.status.forTrade).to(equal(false))
                    expect(game!.status.wantInTrade).to(equal(false))
                    expect(game!.status.wantToPlay).to(equal(false))
                    expect(game!.status.wantToBuy).to(equal(false))
                    expect(game!.status.wishList).to(equal(false))
                    expect(game!.status.preOrdered).to(equal(false))
                    expect(game!.status.wishListPriority).to(beNil())
                }

                it("should not have any optional values populated") {
                    expect(game!.imagePath).to(beNil())
                    expect(game!.imageUrl).to(beNil())
                    expect(game!.thumbnailPath).to(beNil())
                    expect(game!.thumbnailUrl).to(beNil())
                    expect(game!.wishListComment).to(beNil())
                    expect(game!.comment).to(beNil())
                    expect(game!.numPlays).to(beNil())
                    expect(game!.yearPublished).to(beNil())
                    expect(game!.comment).to(beNil())
                    expect(game!.stats).to(beNil())
                }
            }

            context("from a brief xml with statistics") {
                let xml =
                    "<item objecttype=\"thing\" objectid=\"222\" subtype=\"boardgame\" collid=\"22\">" +
                    "    <name sortindex=\"3\">A Brief Game With Stats</name>" +
                    "    <stats minplayers=\"4\" maxplayers=\"8\" minplaytime=\"120\" maxplaytime=\"480\" playingtime=\"240\" numowned=\"2222\">" +
                    "        <rating value=\"8.5\">" +
                    "            <average value=\"7.79921\"/>" +
                    "            <bayesaverage value=\"7.58107\"/>" +
                    "        </rating>" +
                    "    </stats>" +
                    "    <status own=\"0\" prevowned=\"0\" fortrade=\"0\" want=\"0\" wanttoplay=\"1\" wanttobuy=\"0\" wishlist=\"1\" wishlistpriority=\"3\" preordered=\"0\" lastmodified=\"2015-12-18 09:38:29\"/>" +
                    "</item>"

                beforeEach {
                    parser = SWXMLHash.parse(xml)
                    game = try! parser!["item"].value()
                }

                it("should fully parse") {
                    expect(game).toNot(beNil())
                }

                it("should have an objectId") {
                    expect(game!.objectId).to(equal(222))
                }

                it("should have a name") {
                    expect(game!.name).to(equal("A Brief Game With Stats"))
                    expect(game!.sortName).to(equal("Brief Game With Stats"))
                }

                it("should have a status block where wanttoplay and wishlist are true and wishlist priority is set") {
                    expect(game!.status.owned).to(equal(false))
                    expect(game!.status.prevOwned).to(equal(false))
                    expect(game!.status.forTrade).to(equal(false))
                    expect(game!.status.wantInTrade).to(equal(false))
                    expect(game!.status.wantToPlay).to(equal(true))
                    expect(game!.status.wantToBuy).to(equal(false))
                    expect(game!.status.wishList).to(equal(true))
                    expect(game!.status.preOrdered).to(equal(false))
                    expect(game!.status.wishListPriority).to(equal(3))
                }

                it("should have a simple stats block") {
                    expect(game!.stats).toNot(beNil())
                    let stats = game!.stats!
                    expect(stats.minPlayers).to(equal(4))
                    expect(stats.maxPlayers).to(equal(8))
                    expect(stats.minPlaytime).to(equal(120))
                    expect(stats.maxPlaytime).to(equal(480))
                    expect(stats.playingTime).to(equal(240))
                    expect(stats.numOwned).to(equal(2222))

                    expect(stats.rating.userRating).to(beCloseTo(8.5))
                    expect(stats.rating.averageRating).to(beCloseTo(7.79921))
                    expect(stats.rating.bayesAverageRating).to(beCloseTo(7.58107))
                }

                it("should not have any other optional values populated") {
                    expect(game!.imagePath).to(beNil())
                    expect(game!.imageUrl).to(beNil())
                    expect(game!.thumbnailPath).to(beNil())
                    expect(game!.thumbnailUrl).to(beNil())
                    expect(game!.wishListComment).to(beNil())
                    expect(game!.comment).to(beNil())
                    expect(game!.numPlays).to(beNil())
                    expect(game!.yearPublished).to(beNil())
                    expect(game!.comment).to(beNil())
                }
            }

            context("from a standard xml") {

                let xml =
                    "<item objecttype=\"thing\" objectid=\"333\" subtype=\"boardgame\" collid=\"33\">" +
                    "    <name sortindex=\"1\">Standard Game</name>" +
                    "    <yearpublished>2016</yearpublished>" +
                    "    <image>//path.to/image.jpg</image>" +
                    "    <thumbnail>//path.to/thumbnail.jpg</thumbnail>" +
                    "    <status own=\"0\" prevowned=\"1\" fortrade=\"0\" want=\"0\" wanttoplay=\"0\" wanttobuy=\"0\" wishlist=\"0\" preordered=\"0\" lastmodified=\"2016-04-04 20:19:37\"/>" +
                    "    <numplays>1</numplays>" +
                    "    <comment>" +
                    "        Standard Comment" +
                    "    </comment>" +
                    "</item>"

                beforeEach {
                    parser = SWXMLHash.parse(xml)
                    game = try! parser!["item"].value()
                }

                it("should fully parse") {
                    expect(game).toNot(beNil())
                }

                it("should have an objectId") {
                    expect(game!.objectId).to(equal(333))
                }

                it("should have a name") {
                    expect(game!.name).to(equal("Standard Game"))
                    expect(game!.sortName).to(equal("Standard Game"))
                }

                it("should have a status block where only prevowned is true") {
                    expect(game!.status.owned).to(equal(false))
                    expect(game!.status.prevOwned).to(equal(true))
                    expect(game!.status.forTrade).to(equal(false))
                    expect(game!.status.wantInTrade).to(equal(false))
                    expect(game!.status.wantToPlay).to(equal(false))
                    expect(game!.status.wantToBuy).to(equal(false))
                    expect(game!.status.wishList).to(equal(false))
                    expect(game!.status.preOrdered).to(equal(false))
                    expect(game!.status.wishListPriority).to(beNil())
                }

                it("should have a publication year") {
                    expect(game!.yearPublished).to(equal(2016))
                }

                it("should have an image and thumbnail URL") {
                    expect(game!.imagePath).to(equal("//path.to/image.jpg"))
                    expect(game!.imageUrl).toNot(beNil())
                    expect(game!.imageUrl!.absoluteString).to(equal("http://path.to/image.jpg"))

                    expect(game!.thumbnailPath).to(equal("//path.to/thumbnail.jpg"))
                    expect(game!.thumbnailUrl).toNot(beNil())
                    expect(game!.thumbnailUrl!.absoluteString).to(equal("http://path.to/thumbnail.jpg"))
                }

                it("should have plays logged") {
                    expect(game!.numPlays).to(equal(1))
                }

                it("should have a comment") {
                    expect(game!.comment).to(equal("Standard Comment"))
                }

                it("should not have a wishlist comment") {
                    expect(game!.wishListComment).to(beNil())
                }

                it("should not have a statistics block") {
                    expect(game!.stats).to(beNil())
                }
            }

            context("from a standard xml with statistics") {

                let xml =
                    "<item objecttype=\"thing\" objectid=\"444\" subtype=\"boardgame\" collid=\"44\">" +
                    "    <name sortindex=\"3\">A Game With Stats</name>" +
                    "    <yearpublished>2016</yearpublished>" +
                    "    <image>//path.to/image.jpg</image>" +
                    "    <thumbnail>//path.to/thumbnail.jpg</thumbnail>" +
                    "    <stats minplayers=\"1\" maxplayers=\"2\" minplaytime=\"20\" maxplaytime=\"60\" playingtime=\"45\" numowned=\"4444\">" +
                    "        <rating value=\"N/A\">" +
                    "            <usersrated value=\"70\"/>" +
                    "            <average value=\"7.66143\"/>" +
                    "            <bayesaverage value=\"5.68734\"/>" +
                    "            <stddev value=\"0.795755\"/>" +
                    "            <median value=\"0\"/>" +
                    "            <ranks>" +
                    "                <rank type=\"subtype\" id=\"1\" name=\"boardgame\" friendlyname=\"Board Game Rank\" value=\"3785\" bayesaverage=\"5.68734\"/>" +
                    "                <rank type=\"family\" id=\"5497\" name=\"strategygames\" friendlyname=\"Strategy Game Rank\" value=\"20\" bayesaverage=\"7.74838\"/>" +
                    "            </ranks>" +
                    "        </rating>" +
                    "    </stats>" +
                    "    <status own=\"1\" prevowned=\"0\" fortrade=\"1\" want=\"0\" wanttoplay=\"0\" wanttobuy=\"0\" wishlist=\"0\" preordered=\"0\" lastmodified=\"2016-04-04 20:19:37\"/>" +
                    "    <numplays>2</numplays>" +
                    "    <wishlistcomment>" +
                    "        Wish List Comment" +
                    "    </wishlistcomment>" +
                    "</item>"

                beforeEach {
                    parser = SWXMLHash.parse(xml)
                    game = try! parser!["item"].value()
                }

                it("should fully parse") {
                    expect(game).toNot(beNil())
                }

                it("should have an objectId") {
                    expect(game!.objectId).to(equal(444))
                }

                it("should have a name") {
                    expect(game!.name).to(equal("A Game With Stats"))
                    expect(game!.sortName).to(equal("Game With Stats"))
                }

                it("should have a status block where owned and fortrade is true") {
                    expect(game!.status.owned).to(equal(true))
                    expect(game!.status.prevOwned).to(equal(false))
                    expect(game!.status.forTrade).to(equal(true))
                    expect(game!.status.wantInTrade).to(equal(false))
                    expect(game!.status.wantToPlay).to(equal(false))
                    expect(game!.status.wantToBuy).to(equal(false))
                    expect(game!.status.wishList).to(equal(false))
                    expect(game!.status.preOrdered).to(equal(false))
                    expect(game!.status.wishListPriority).to(beNil())
                }

                it("should have a publication year") {
                    expect(game!.yearPublished).to(equal(2016))
                }

                it("should have an image and thumbnail URL") {
                    expect(game!.imagePath).to(equal("//path.to/image.jpg"))
                    expect(game!.imageUrl).toNot(beNil())
                    expect(game!.imageUrl!.absoluteString).to(equal("http://path.to/image.jpg"))
                    expect(game!.thumbnailPath).to(equal("//path.to/thumbnail.jpg"))
                    expect(game!.thumbnailUrl).toNot(beNil())
                    expect(game!.thumbnailUrl!.absoluteString).to(equal("http://path.to/thumbnail.jpg"))
                }

                it("should have plays logged") {
                    expect(game!.numPlays).to(equal(2))
                }

                it("should not have a comment") {
                    expect(game!.comment).to(beNil())
                }

                it("should have a wishlist comment") {
                    expect(game!.wishListComment).to(equal("Wish List Comment"))
                }

                it("should have a statistics block") {
                    expect(game!.stats).toNot(beNil())
                    let stats = game!.stats!
                    expect(stats.minPlayers).to(equal(1))
                    expect(stats.maxPlayers).to(equal(2))
                    expect(stats.minPlaytime).to(equal(20))
                    expect(stats.maxPlaytime).to(equal(60))
                    expect(stats.playingTime).to(equal(45))
                    expect(stats.numOwned).to(equal(4444))
                }

                it("should have a rating block") {
                    expect(game!.stats!.rating).toNot(beNil())
                    let rating = game!.stats!.rating
                    expect(rating.userRating).to(beNil())
                    expect(rating.usersRated).to(equal(70))
                    expect(rating.averageRating).to(beCloseTo(7.66143))
                    expect(rating.bayesAverageRating).to(beCloseTo(5.68734))
                    expect(rating.stdDev).to(beCloseTo(0.795755))
                    expect(rating.median).to(beCloseTo(0.0))
                }

                it("should have ranks") {
                    expect(game!.stats!.rating.ranks).toNot(beNil())
                    let ranks = game!.stats!.rating.ranks!
                    expect(ranks.count).to(equal(2))
                    expect(ranks[0].type).to(equal("subtype"))
                    expect(ranks[0].id).to(equal(1))
                    expect(ranks[0].name).to(equal("boardgame"))
                    expect(ranks[0].friendlyName).to(equal("Board Game Rank"))
                    expect(ranks[0].value).to(equal(3785))
                    expect(ranks[0].bayesAverage).to(beCloseTo(5.68734))

                    expect(ranks[1].type).to(equal("family"))
                    expect(ranks[1].id).to(equal(5497))
                    expect(ranks[1].name).to(equal("strategygames"))
                    expect(ranks[1].friendlyName).to(equal("Strategy Game Rank"))
                    expect(ranks[1].value).to(equal(20))
                    expect(ranks[1].bayesAverage).to(beCloseTo(7.74838))
                }
            }

            context("with invalid XML elements") {
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
    }
}
