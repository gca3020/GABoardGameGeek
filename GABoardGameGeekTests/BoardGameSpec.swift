//
// Created by Geoffrey Amey on 4/22/16.
// Copyright (c) 2016 Geoffrey Amey. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SWXMLHash

@testable import GABoardGameGeek

class BoardGameSpec: QuickSpec {

    override func spec() {

        describe("a standard board game") {
            var game: BoardGame?
            var parser: XMLIndexer?

            context("from an xml without stats") {
                let xml =
                "<item type=\"boardgame\" id=\"161936\">" +
                "   <thumbnail>//cf.geekdo-images.com/images/pic2452831_t.png</thumbnail>" +
                "   <image>//cf.geekdo-images.com/images/pic2452831.png</image>" +
                "   <name type=\"primary\" sortindex=\"1\" value=\"Pandemic Legacy: Season 1\"/>" +
                "   <name type=\"alternate\" sortindex=\"1\" value=\"Pandemic Legacy: Seizoen 1\"/>" +
                "   <name type=\"alternate\" sortindex=\"1\" value=\"Пандемия: Наследие\"/>" +
                "   <name type=\"alternate\" sortindex=\"1\" value=\"瘟疫危機︰承傳\"/>" +
                "   <description>" +
                "       Description" +
                "   </description>" +
                "   <yearpublished value=\"2015\"/>" +
                "   <minplayers value=\"2\"/>" +
                "   <maxplayers value=\"4\"/>" +
                "   <poll name=\"suggested_numplayers\" title=\"User Suggested Number of Players\" totalvotes=\"199\">" +
                "       <results numplayers=\"1\">" +
                "           <result value=\"Best\" numvotes=\"7\"/>" +
                "           <result value=\"Recommended\" numvotes=\"33\"/>" +
                "           <result value=\"Not Recommended\" numvotes=\"79\"/>" +
                "       </results>" +
                "       <results numplayers=\"2\">" +
                "           <result value=\"Best\" numvotes=\"26\"/>" +
                "           <result value=\"Recommended\" numvotes=\"101\"/>" +
                "           <result value=\"Not Recommended\" numvotes=\"22\"/>" +
                "       </results>" +
                "       <results numplayers=\"3\">" +
                "           <result value=\"Best\" numvotes=\"31\"/>" +
                "           <result value=\"Recommended\" numvotes=\"93\"/>" +
                "           <result value=\"Not Recommended\" numvotes=\"15\"/>" +
                "       </results>" +
                "           <results numplayers=\"4\">" +
                "           <result value=\"Best\" numvotes=\"111\"/>" +
                "           <result value=\"Recommended\" numvotes=\"53\"/>" +
                "           <result value=\"Not Recommended\" numvotes=\"6\"/>" +
                "       </results>" +
                "       <results numplayers=\"4+\">" +
                "           <result value=\"Best\" numvotes=\"6\"/>" +
                "           <result value=\"Recommended\" numvotes=\"1\"/>" +
                "           <result value=\"Not Recommended\" numvotes=\"81\"/>" +
                "       </results>" +
                "   </poll>" +
                "   <playingtime value=\"60\"/>" +
                "   <minplaytime value=\"60\"/>" +
                "   <maxplaytime value=\"60\"/>" +
                "   <minage value=\"13\"/>" +
                "   <poll name=\"suggested_playerage\" title=\"User Suggested Player Age\" totalvotes=\"60\">" +
                "       <results>" +
                "           <result value=\"2\" numvotes=\"0\"/>" +
                "           <result value=\"3\" numvotes=\"0\"/>" +
                "           <result value=\"4\" numvotes=\"0\"/>" +
                "           <result value=\"5\" numvotes=\"0\"/>" +
                "           <result value=\"6\" numvotes=\"1\"/>" +
                "           <result value=\"8\" numvotes=\"6\"/>" +
                "           <result value=\"10\" numvotes=\"15\"/>" +
                "           <result value=\"12\" numvotes=\"24\"/>" +
                "           <result value=\"14\" numvotes=\"11\"/>" +
                "           <result value=\"16\" numvotes=\"2\"/>" +
                "           <result value=\"18\" numvotes=\"0\"/>" +
                "           <result value=\"21 and up\" numvotes=\"1\"/>" +
                "       </results>" +
                "   </poll>" +
                "   <poll name=\"language_dependence\" title=\"Language Dependence\" totalvotes=\"63\">" +
                "       <results>" +
                "           <result level=\"1\" value=\"No necessary in-game text\" numvotes=\"1\"/>" +
                "           <result level=\"2\" value=\"Some necessary text - easily memorized or small crib sheet\" numvotes=\"0\"/>" +
                "           <result level=\"3\" value=\"Moderate in-game text - needs crib sheet or paste ups\" numvotes=\"8\"/>" +
                "           <result level=\"4\" value=\"Extensive use of text - massive conversion needed to be playable\" numvotes=\"44\"/>" +
                "           <result level=\"5\" value=\"Unplayable in another language\" numvotes=\"10\"/>" +
                "       </results>" +
                "   </poll>" +
                "   <link type=\"boardgamecategory\" id=\"1084\" value=\"Environmental\"/>" +
                "   <link type=\"boardgameimplementation\" id=\"30549\" value=\"Pandemic\" inbound=\"true\"/>" +
                "</item>"

                beforeEach {
                    parser = SWXMLHash.parse(xml)
                    game = try? parser!["item"].value()
                }

                it("should fully parse") {
                    expect(game).toNot(beNil())
                }

                it("should have an objectId and type") {
                    expect(game!.objectId).to(equal(161936))
                    expect(game!.type).to(equal("boardgame"))
                }

                it("should have a name") {
                    expect(game!.name).to(equal("Pandemic Legacy: Season 1"))
                    expect(game!.sortIndex).to(equal(1))
                    expect(game!.sortName).to(equal("Pandemic Legacy: Season 1"))
                }

                it("should have a description") {
                    expect(game!.description).to(equal("Description"))
                }

                it("should have image and thumbnail URLs") {
                    expect(game!.thumbnailPath).to(equal("//cf.geekdo-images.com/images/pic2452831_t.png"))
                    expect(game!.imagePath).to(equal("//cf.geekdo-images.com/images/pic2452831.png"))
                }

                it("should have additional data about the game") {
                    expect(game!.yearPublished).to(equal(2015))
                    expect(game!.minPlayers).to(equal(2))
                    expect(game!.maxPlayers).to(equal(4))
                    expect(game!.minPlaytime).to(equal(60))
                    expect(game!.maxPlaytime).to(equal(60))
                    expect(game!.playingTime).to(equal(60))
                    expect(game!.minAge).to(equal(13))
                }

                it("should have a player count poll") {
                    expect(game!.suggestedPlayers.totalVotes).to(equal(199))
                    expect(game!.suggestedPlayers.results).toNot(beNil())
                    expect(game!.suggestedPlayers.results).to(haveCount(5))
                    expect(game!.suggestedPlayers.results!["4"]).to(haveCount(3))
                    expect(game!.suggestedPlayers.results!["4+"]).to(haveCount(3))
                    expect(game!.suggestedPlayers.results!["5"]).to(beNil())
                }

                it("should have a player age poll") {
                    expect(game!.suggestedPlayerage.totalVotes).to(equal(60))
                    expect(game!.suggestedPlayerage.results).toNot(beNil())
                    expect(game!.suggestedPlayerage.results).to(haveCount(12))
                }

                it("should have a language dependence poll") {
                    expect(game!.languageDependence.totalVotes).to(equal(63))
                    expect(game!.languageDependence.results).toNot(beNil())
                    expect(game!.languageDependence.results).to(haveCount(5))
                }

                it("should have a collection of links") {
                    expect(game!.links).to(haveCount(2))

                    expect(game!.links[0].type).to(equal("boardgamecategory"))
                    expect(game!.links[0].id).to(equal(1084))
                    expect(game!.links[0].value).to(equal("Environmental"))
                    expect(game!.links[0].inbound).to(beNil())

                    expect(game!.links[1].type).to(equal("boardgameimplementation"))
                    expect(game!.links[1].id).to(equal(30549))
                    expect(game!.links[1].value).to(equal("Pandemic"))
                    expect(game!.links[1].inbound).to(beTrue())
                }

                it("should not have a statistics block") {
                    expect(game!.stats).to(beNil())
                }
            }

            context("from a minimal xml with stats") {
                let xml =
                "<item type=\"boardgame\" id=\"123\">" +
                "   <name type=\"primary\" sortindex=\"3\" value=\"A Made-Up Game\"/>" +
                "   <description>" +
                "       A made-up game" +
                "   </description>" +
                "   <yearpublished value=\"1984\"/>" +
                "   <minplayers value=\"1\"/>" +
                "   <maxplayers value=\"100\"/>" +
                "   <poll name=\"suggested_numplayers\" title=\"User Suggested Number of Players\" totalvotes=\"0\">" +
                "       <results numplayers=\"0+\"></results>" +
                "   </poll>" +
                "   <playingtime value=\"0\"/>" +
                "   <minplaytime value=\"0\"/>" +
                "   <maxplaytime value=\"0\"/>" +
                "   <minage value=\"0\"/>" +
                "   <poll name=\"suggested_playerage\" title=\"User Suggested Player Age\" totalvotes=\"0\"></poll>" +
                "   <poll name=\"language_dependence\" title=\"Language Dependence\" totalvotes=\"0\"></poll>" +
                "   <link type=\"boardgamepublisher\" id=\"4\" value=\"(Self-Published)\"/>" +
                "   <statistics page=\"1\">" +
                "       <ratings>" +
                "           <usersrated value=\"1\"/>" +
                "           <average value=\"5.5\"/>" +
                "           <bayesaverage value=\"4.0\"/>" +
                "           <ranks>" +
                "               <rank type=\"subtype\" id=\"1\" name=\"boardgame\" friendlyname=\"Board Game Rank\" value=\"Not Ranked\" bayesaverage=\"Not Ranked\"/>" +
                "           </ranks>" +
                "           <stddev value=\"0.1\"/>" +
                "           <median value=\"0\"/>" +
                "           <owned value=\"5\"/>" +
                "           <trading value=\"0\"/>" +
                "           <wanting value=\"3\"/>" +
                "           <wishing value=\"1\"/>" +
                "           <numcomments value=\"2\"/>" +
                "           <numweights value=\"1\"/>" +
                "           <averageweight value=\"2.7\"/>" +
                "       </ratings>" +
                "   </statistics>" +
                "</item>"

                beforeEach {
                    parser = SWXMLHash.parse(xml)
                    do {
                        game = try parser!["item"].value()
                    } catch {
                        print("Error Info: \(error)")
                    }
                }

                it("should fully parse") {
                    expect(game).toNot(beNil())
                }

                it("should have an objectId and type") {
                    expect(game!.objectId).to(equal(123))
                    expect(game!.type).to(equal("boardgame"))
                }

                it("should have a name") {
                    expect(game!.name).to(equal("A Made-Up Game"))
                    expect(game!.sortIndex).to(equal(3))
                    expect(game!.sortName).to(equal("Made-Up Game"))
                }

                it("should have a description") {
                    expect(game!.description).to(equal("A made-up game"))
                }

                it("should not have image and thumbnail URLs") {
                    expect(game!.thumbnailPath).to(beNil())
                    expect(game!.imagePath).to(beNil())
                }

                it("should have additional data about the game") {
                    expect(game!.yearPublished).to(equal(1984))
                    expect(game!.minPlayers).to(equal(1))
                    expect(game!.maxPlayers).to(equal(100))
                    expect(game!.minPlaytime).to(equal(0))
                    expect(game!.maxPlaytime).to(equal(0))
                    expect(game!.playingTime).to(equal(0))
                    expect(game!.minAge).to(equal(0))
                }

                it("should have an empty player count poll") {
                    expect(game!.suggestedPlayers.totalVotes).to(equal(0))
                    expect(game!.suggestedPlayers.results).to(beNil())
                }

                it("should have an empty player age poll") {
                    expect(game!.suggestedPlayerage.totalVotes).to(equal(0))
                    expect(game!.suggestedPlayerage.results).to(beNil())
                }

                it("should have an empty language dependence poll") {
                    expect(game!.languageDependence.totalVotes).to(equal(0))
                    expect(game!.languageDependence.results).to(beNil())
                }

                it("should have one link") {
                    expect(game!.links).to(haveCount(1))

                    expect(game!.links[0].type).to(equal("boardgamepublisher"))
                    expect(game!.links[0].id).to(equal(4))
                    expect(game!.links[0].value).to(equal("(Self-Published)"))
                    expect(game!.links[0].inbound).to(beNil())
                }

                it("should have a statistics block") {
                    expect(game!.stats).toNot(beNil())
                    expect(game!.stats!.usersRated).to(equal(1))
                    expect(game!.stats!.average).to(beCloseTo(5.5))
                    expect(game!.stats!.bayesAverage).to(beCloseTo(4.0))
                    expect(game!.stats!.stdDev).to(beCloseTo(0.1))
                    expect(game!.stats!.median).to(beCloseTo(0.0))
                    expect(game!.stats!.owned).to(equal(5))
                    expect(game!.stats!.trading).to(equal(0))
                    expect(game!.stats!.wanting).to(equal(3))
                    expect(game!.stats!.wishing).to(equal(1))
                    expect(game!.stats!.numComments).to(equal(2))
                    expect(game!.stats!.numWeights).to(equal(1))
                    expect(game!.stats!.averageWeight).to(beCloseTo(2.7))

                    expect(game!.stats!.ranks).to(haveCount(1))
                    expect(game!.stats!.ranks[0].type).to(equal("subtype"))
                    expect(game!.stats!.ranks[0].id).to(equal(1))
                    expect(game!.stats!.ranks[0].name).to(equal("boardgame"))
                    expect(game!.stats!.ranks[0].friendlyName).to(equal("Board Game Rank"))
                    expect(game!.stats!.ranks[0].value).to(equal(0))
                    expect(game!.stats!.ranks[0].bayesAverage).to(beCloseTo(0.0))
                }
            }
        }
    }
}
