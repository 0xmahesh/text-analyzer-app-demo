//
//  FileHandlerTests.swift
//  BookReaderAppTests
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import Foundation

import XCTest
@testable import BookReaderApp

class FileHandlerTests: XCTestCase {
    
    var fileHandler: FileHandler!
    fileprivate var mockWordCounter: MockWordProcessable!

    override func setUp() {
        super.setUp()
        mockWordCounter = MockWordProcessable()
        fileHandler = FileHandler(chunkSize: 512, wordCounter: mockWordCounter)
    }

    override func tearDown() {
        super.tearDown()
        fileHandler = nil
        mockWordCounter = nil
    }

    func testProcessTextFileEmptyFile() async {
        let testFilePath = URL(fileURLWithPath: "empty.txt")
        let testFileContent = ""
        try? testFileContent.write(to: testFilePath, atomically: true, encoding: .utf8)
        defer {
            try? FileManager.default.removeItem(at: testFilePath)
        }

        let (success, wordDictionary) = await fileHandler.processTextFile(at: testFilePath, filename: "empty.txt")

        XCTAssertFalse(success)
        XCTAssertNil(wordDictionary)
    }

    func testProcessTextFileNonExistentFile() async throws {
        let testFilePath = URL(fileURLWithPath: "nonexistent.txt")

        let (success, wordDictionary) = await fileHandler.processTextFile(at: testFilePath, filename: "nonexistent.txt")

        XCTAssertFalse(success)
        XCTAssertNil(wordDictionary)
    }
    
    func testProcessTextFileSingleLine() async throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testFilePath = tempDir.appendingPathComponent("single_line.txt")
        let testFileContent = "This is a single line with multiple words."
        try? testFileContent.write(to: testFilePath, atomically: true, encoding: .utf8)
        defer {
            try? FileManager.default.removeItem(at: testFilePath)
        }

        let (success, wordDictionary) = await fileHandler.processTextFile(at: testFilePath, filename: "single_line.txt")

        XCTAssertTrue(success)
        XCTAssertNotNil(wordDictionary)

        XCTAssertEqual(wordDictionary!["This"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["is"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["a"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["single"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["line"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["with"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["multiple"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["words"]?.frequency, 1)
    }
    
    func testProcessTextFileMultipleLines() async throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testFilePath = tempDir.appendingPathComponent("multiple_lines.txt")
        let testFileContent = "This is line 1 with words.\nLine 2 has more words.\nLine 3 is here."
        try? testFileContent.write(to: testFilePath, atomically: true, encoding: .utf8)
        defer {
            try? FileManager.default.removeItem(at: testFilePath)
        }

        let (success, wordDictionary) = await fileHandler.processTextFile(at: testFilePath, filename: "multiple_lines.txt")

        XCTAssertTrue(success)
        XCTAssertNotNil(wordDictionary)

        XCTAssertEqual(wordDictionary!["This"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["is"]?.frequency, 2)
        XCTAssertEqual(wordDictionary!["line"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["1"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["with"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["words"]?.frequency, 2)
        XCTAssertEqual(wordDictionary!["Line"]?.frequency, 2)
        XCTAssertEqual(wordDictionary!["2"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["has"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["more"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["3"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["here"]?.frequency, 1)
    }
    
    func testProcessTextFileSpecialCharacters() async throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testFilePath = tempDir.appendingPathComponent("special_characters.txt")
        let testFileContent = "Special characters: !@#$%^&*()_+{}[]|\"'<>,.?/\\"
        try? testFileContent.write(to: testFilePath, atomically: true, encoding: .utf8)
        defer {
            try? FileManager.default.removeItem(at: testFilePath)
        }

        let (success, wordDictionary) = await fileHandler.processTextFile(at: testFilePath, filename: "special_characters.txt")

        XCTAssertTrue(success)
        XCTAssertNotNil(wordDictionary)

        XCTAssertEqual(wordDictionary!["Special"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["characters"]?.frequency, 1)
        XCTAssertNil(wordDictionary!["!@#$%^&*()_+{}[]|\"'<>,.?/\\"])
    }
    
    func testProcessTextFileNumericValues() async throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testFilePath = tempDir.appendingPathComponent("numeric_values.txt")
        let testFileContent = "12345 678 90 0"
        try? testFileContent.write(to: testFilePath, atomically: true, encoding: .utf8)
        defer {
            try? FileManager.default.removeItem(at: testFilePath)
        }

        let (success, wordDictionary) = await fileHandler.processTextFile(at: testFilePath, filename: "numeric_values.txt")

        XCTAssertTrue(success)
        XCTAssertNotNil(wordDictionary)

        XCTAssertEqual(wordDictionary!["12345"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["678"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["90"]?.frequency, 1)
        XCTAssertEqual(wordDictionary!["0"]?.frequency, 1)
    }

    
    func testProcessTextFilePerformanceWithLargeFile() async throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testFilePath = tempDir.appendingPathComponent("large_file.txt")
        let testFileContent = String(repeating: "This is a large file with many words. ", count: 1_000_000)
        try? testFileContent.write(to: testFilePath, atomically: true, encoding: .utf8)
        defer {
            try? FileManager.default.removeItem(at: testFilePath)
        }

        let expectation = self.expectation(description: "Performance test")
        
        measure {
            Task {
                let (success, _) = await fileHandler.processTextFile(at: testFilePath, filename: "large_file.txt")
                XCTAssertTrue(success)
            }
        }
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 10)
    }
}

private actor MockWordProcessable: WordProcessable {
    
    var wordDictionary: WordInfoDict = [:]
    
    func countWords(in line: String) async {
        let words = line.components(separatedBy: .whitespacesAndNewlines)
        for word in words {
            let trimmedWord = word.trimmingCharacters(in: .punctuationCharacters)
            if var wordInfo = wordDictionary[trimmedWord] {
                wordInfo.frequency += 1
                wordDictionary[trimmedWord] = wordInfo
            } else {
                wordDictionary[trimmedWord] = WordInfo(word: trimmedWord, frequency: 1, scrabbleScore: 0)
            }
        }
    }
    
    func getWordDictionary() -> WordInfoDict {
        return wordDictionary
    }
    
    nonisolated func sanitizeWord(_ word: String) -> String {
        return word.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: .punctuationCharacters)
    }
}
