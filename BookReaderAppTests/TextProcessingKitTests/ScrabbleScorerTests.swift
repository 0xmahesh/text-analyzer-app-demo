//
//  ScrabbleScorerTests.swift
//  BookReaderAppTests
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import XCTest
@testable import BookReaderApp

class ScrabbleWordScorerTests: XCTestCase {
    var scorer: ScrabbleWordScorer!
    
    override func setUp() {
        super.setUp()
        scorer = ScrabbleWordScorer()
    }
    
    func testValidWord_hasAScore() async {
        let score = await scorer.calculateScore(for: "Hello")
        XCTAssertEqual(score, 8)
    }
    
    func testValidWordWithDiacritics_scoreIsZero() async {
        let score = await scorer.calculateScore(for: "Café")
        XCTAssertEqual(score, 0)
    }
    
    func testEmptyInput_scoreIsZero() async {
        let score = await scorer.calculateScore(for: "")
        XCTAssertEqual(score, 0)
    }
    
    func testWordWithHyphens_scoreIsZero() async {
        let score = await scorer.calculateScore(for: "far-fetched")
        XCTAssertEqual(score, 0)
    }
    
    func testInvalidWord_scoreIsZero() async {
        let score = await scorer.calculateScore(for: "XYZ123")
        XCTAssertEqual(score, 0)
    }
    
    func testWordWithDuplicateLetters_hasAscore() async {
        let score = await scorer.calculateScore(for: "MISSISSIPPI")
        XCTAssertEqual(score, 17)
    }
    
    func testTextwithSpecialCharacters_scoreIsZero() async {
        let score = await scorer.calculateScore(for: "$500.0")
        XCTAssertEqual(score, 0)
    }
    
    func testWordExceedingMaxLength() async {
        let longWord = String(repeating: "A", count: 16) // Scrabble max length is 15
        let score = await scorer.calculateScore(for: longWord)
        XCTAssertEqual(score, 0)
    }
    
    func testPerformance() async {
        let expectation = expectation(description: "performance test")
        measure {
            Task {
                for _ in 1...1000 {
                    _ = await scorer.calculateScore(for: "Hello")
                }
            }
        }
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 10)

    }
}
