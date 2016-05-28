//
//  ApiSpec.swift
//  GABoardGameGeek
//
//  Created by Geoffrey Amey on 4/24/16.
//  Copyright © 2016 Geoffrey Amey. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import GABoardGameGeek

class ApiSpec: QuickSpec {

    override func spec() {

        describe("a collection request") {

            it("should do something") {
                var userGames: [CollectionBoardGame]?
                
                GABoardGameGeek().getUserCollection("gca3020", brief: false, stats: true) { result in
                    switch(result)
                    {
                    case .Success(let games):
                        userGames = games
                        print(userGames)
                    case .Failure(let error):
                        print("The request Failed: \(error)")
                    }
                }
                expect(userGames).toEventuallyNot(beNil(), timeout: 150)
            }
        }

        describe("a game request") {

            it("should do something") {
                var games: [BoardGame]?
                GABoardGameGeek().getGamesById([89575, 173404], stats: true) { result in
                    switch(result)
                    {
                    case .Success(let gameList):
                        games = gameList
                        //print(games)
                    case .Failure(let error):
                        print("The request Failed: \(error)")
                    }
                }
                expect(games).toEventuallyNot(beNil(), timeout: 150)
            }

        }


    }
}