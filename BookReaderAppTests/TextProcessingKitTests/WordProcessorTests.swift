//
//  WordProcessorTests.swift
//  BookReaderAppTests
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import XCTest
@testable import BookReaderApp

class WordProcessorTests: XCTestCase {
    
    var wordProcessor: WordProcessable!
    var mockScrabbleScorer: ScrabbleWordScorable!
    var wordExtractionRegexPattern: String!
    
    override func setUp() {
        mockScrabbleScorer = MockScrabbleWordScorer()
        wordExtractionRegexPattern = Constants.wordExtractionRegexPattern
        wordProcessor = WordProcessor(scrabbleWordScorer: mockScrabbleScorer, wordExtractionRegexPattern: wordExtractionRegexPattern)
    }
    
    override func tearDown() {
        super.tearDown()
        mockScrabbleScorer = nil
    }
    
    func testWordCounting_emptyInput() async throws {
        try await wordProcessor.countWords(in: "")
        let dict = await wordProcessor.getWordDictionary()
        
        XCTAssertTrue(dict.isEmpty)
    }
    
    func testWordCounting_withWordsAndPunctuation() async throws {
        try await wordProcessor.countWords(in: "Hello, world!")
        let dict = await wordProcessor.getWordDictionary()
        
        XCTAssertEqual(dict.count, 2)
        XCTAssertEqual(dict["Hello"]?.frequency, 1)
        XCTAssertEqual(dict["world"]?.frequency, 1)
    }
    
    func testWordCounting_frequencyIncrement() async throws {
        try await wordProcessor.countWords(in: "Hello, world!")
        try await wordProcessor.countWords(in: "Hello, world!")
        let dict = await wordProcessor.getWordDictionary()
        
        XCTAssertEqual(dict["Hello"]?.frequency, 2)
        XCTAssertEqual(dict["world"]?.frequency, 2)
    }
    
    func testWordSanitization() {
        XCTAssertEqual(wordProcessor.sanitizeWord("hello"), "hello")
        XCTAssertEqual(wordProcessor.sanitizeWord(" world "), "world")
        XCTAssertEqual(wordProcessor.sanitizeWord(" Word! "), "Word")
    }

    func testPerformance() async {
        let expectation = expectation(description: "performance test")
        measure {
            Task {
                for _ in 1...1000 {
                    try? await wordProcessor.countWords(in: "time is a flat circle.")
                }
            }
        }
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 10)
    }
}

private class MockScrabbleWordScorer: ScrabbleWordScorable {
    var letterScores: [Character: Int] = [:]
    func calculateScore(for word: String) -> Int {
        return 0
    }
}
