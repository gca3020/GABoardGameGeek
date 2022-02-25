import XCTest
@testable import GABoardGameGeek

final class GABoardGameGeekTests: XCTestCase {
    func testGetGame() throws {
        let exp = expectation(description: "Check Getting a Game Succeeds")
        var testGame: BoardGame?

        GABoardGameGeek().getGameById(36218) { result in
            switch(result) {
            case .success(let game):
                testGame = game
                exp.fulfill()
            case .failure(let error):
                print(error)
            }
        }

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertNotNil(testGame)
            XCTAssertEqual(testGame?.name, "Dominion")
        }
    }
}
