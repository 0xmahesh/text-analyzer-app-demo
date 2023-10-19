//
//  ProcessFileUseCaseTests.swift
//  BookReaderAppTests
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import XCTest
@testable import BookReaderApp

class StandardProcessFileUseCaseTests: XCTestCase {
    private var processFileUseCase: StandardProcessFileUseCase!
    private var mockFileHandler: MockFileHandler!

    override func setUp() {
        super.setUp()
        mockFileHandler = MockFileHandler()
        processFileUseCase = StandardProcessFileUseCase(fileHandler: mockFileHandler)
    }

    override func tearDown() {
        processFileUseCase = nil
        mockFileHandler = nil
        super.tearDown()
    }

    func testExecuteSuccess() async {
        
        // arrange
        let filePath = URL(fileURLWithPath: "example.txt")
        let fileName = "example.txt"
        let expectedResult: (Bool, WordInfoDict?) = (true, ["word1": WordInfo.mock(), "word2": WordInfo.mock()])

        mockFileHandler.mockProcessTextFileResult = expectedResult

        // act
        let result = await processFileUseCase.execute(filePath: filePath, fileName: fileName)

        // assert
        XCTAssertTrue(result.0)
        XCTAssertNotNil(result.1)
        XCTAssertEqual(result.1?.count, 2)
    }


    func testExecuteFailure() async {
        
        // arrange
        let filePath = URL(fileURLWithPath: "example.txt")
        let fileName = "example.txt"
        let expectedResult: (Bool, WordInfoDict?) = (false, nil)

        mockFileHandler.mockProcessTextFileResult = expectedResult

        // act
        let result = await processFileUseCase.execute(filePath: filePath, fileName: fileName)

        // assert
        XCTAssertFalse(result.0)
        XCTAssertNil(result.1)
    }
}

private class MockFileHandler: FileHandlerProtocol {
    var mockProcessTextFileResult: (Bool, WordInfoDict?) = (false, nil)

    func processTextFile(at filePath: URL, filename: String) async -> (Bool, WordInfoDict?) {
        return mockProcessTextFileResult
    }
}

extension WordInfo {
    static func mock() -> WordInfo {
        return WordInfo(id: UUID(), word: "")
    }
}
