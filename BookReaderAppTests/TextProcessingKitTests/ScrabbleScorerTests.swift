//
//  ScrabbleScorerTests.swift
//  BookReaderAppTests
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import XCTest
@testable import BookReaderApp

class ScrabbleWordScorerTests: XCTestCase {
    var englishScorer: ScrabbleWordScorer!
    var chineseScorer: ScrabbleWordScorer!
    
    override func setUp() {
        super.setUp()
        let englishAlphabet = ScrabbleAlphabet(
            language: .english,
            allowedCodePoints: Constants.englishAlphabetCodePoints,
            letterScores: Constants.englishAlphabetLetterScores)
        
        englishScorer = ScrabbleWordScorer(alphabet: englishAlphabet)
    }
    
    func testValidEnglishWord_hasAScore() async {
        let score = await englishScorer.calculateScore(for: "Hello")
        XCTAssertEqual(score, 8)
    }

    func testValidEnglishWordWithDiacritics_scoreIsZero() async {
        let score = await englishScorer.calculateScore(for: "Café")
        XCTAssertEqual(score, 0)
    }

    func testEmptyInput_scoreIsZero() async {
        let score = await englishScorer.calculateScore(for: "")
        XCTAssertEqual(score, 0)
    }

    func testEnglishWordWithHyphens_scoreIsZero() async {
        let score = await englishScorer.calculateScore(for: "far-fetched")
        XCTAssertEqual(score, 0)
    }

    func testInvalidEnglishWord_scoreIsZero() async {
        let score = await englishScorer.calculateScore(for: "XYZ123")
        XCTAssertEqual(score, 0)
    }

    func testEnglishWordWithDuplicateLetters_hasAScore() async {
        let score = await englishScorer.calculateScore(for: "MISSISSIPPI")
        XCTAssertEqual(score, 17)
    }

    func testTextWithSpecialCharacters_scoreIsZero() async {
        let score = await englishScorer.calculateScore(for: "$500.0")
        XCTAssertEqual(score, 0)
    }

    func testEnglishWordExceedingMaxLength_scoreIsZero() async {
        let longWord = String(repeating: "A", count: 16) // Scrabble max length is 15
        let score = await englishScorer.calculateScore(for: longWord)
        XCTAssertEqual(score, 0)
    }
    
    func testEnglishWordScoringPerformance() async {
        let expectation = expectation(description: "english scorer performance test")
        measure {
            Task {
                for _ in 1...1000 {
                    _ = await englishScorer.calculateScore(for: "Hello")
                }
            }
        }
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 10)

    }

}
