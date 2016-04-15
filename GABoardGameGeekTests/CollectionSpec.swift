//
// Created by Geoffrey Amey on 4/15/16.
// Copyright (c) 2016 Geoffrey Amey. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SWXMLHash

@testable import GABoardGameGeek

class CollectionSpec: QuickSpec {

    override func spec() {

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
                    expect(game!.thumbnailPath).to(beNil())
                    expect(game!.wishListComment).to(beNil())
                    expect(game!.comment).to(beNil())
                    expect(game!.numPlays).to(beNil())
                    expect(game!.yearPublished).to(beNil())
                    expect(game!.comment).to(beNil())
                    expect(game!.stats).to(beNil())
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
                    expect(game!.thumbnailPath).to(equal("//path.to/thumbnail.jpg"))
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


        }
    }
}
