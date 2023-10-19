//
//  HomeViewModelTests.swift
//  BookReaderAppTests
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import XCTest
@testable import BookReaderApp

class HomeViewModelTests: XCTestCase {
    private var viewModel: HomeViewModel!
    private var mockFetchFileUseCase: MockFetchFileUseCase!
    private var mockProcessFileUseCase: MockProcessFileUseCase!
    private var mockPersistBookInfoUseCase: MockPersistBookInfoUseCase!
    private var mockFetchBookInfoUseCase: MockFetchBookInfoUseCase!
    private var mockFetchAllBooksUseCase: MockFetchAllBooksUseCase!
    
    override func setUp() {
        super.setUp()
        
        mockFetchFileUseCase = MockFetchFileUseCase()
        mockProcessFileUseCase = MockProcessFileUseCase()
        mockPersistBookInfoUseCase = MockPersistBookInfoUseCase()
        mockFetchBookInfoUseCase = MockFetchBookInfoUseCase()
        mockFetchAllBooksUseCase = MockFetchAllBooksUseCase()
        
        viewModel = HomeViewModel(
            fetchFileUseCase: mockFetchFileUseCase,
            processFileUseCase: mockProcessFileUseCase,
            persistBookInfoUseCase: mockPersistBookInfoUseCase,
            fetchBookInfoUseCase: mockFetchBookInfoUseCase,
            fetchAllBooksUseCase: mockFetchAllBooksUseCase
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockFetchFileUseCase = nil
        mockProcessFileUseCase = nil
        mockPersistBookInfoUseCase = nil
        mockFetchBookInfoUseCase = nil
        mockFetchAllBooksUseCase = nil
        super.tearDown()
    }
    
    func testDidViewAppear_whenBookStorageIsEmpty() async {
        // arrange
        mockFetchAllBooksUseCase.mockFetchAllBooksResult = []

        // act
        await viewModel.didViewAppear()
        
        // assert
        XCTAssertFalse(viewModel.showHistoryButton)
    }
    
    func testDidViewAppear_whenBookStorageIsNotEmpty() async {
        // arrange
        mockFetchAllBooksUseCase.mockFetchAllBooksResult = [Book.mock()]
        
        // act
        await viewModel.didViewAppear()
        
        // assert
        XCTAssertTrue(viewModel.showHistoryButton)
    }
    
    func testIsBookStorageEmpty_whenBookStorageIsEmpty() async {
        // arrange
        mockFetchAllBooksUseCase.mockFetchAllBooksResult = []
        
        // act
        let isEmpty = await viewModel.isBookStorageEmpty()
        
        // assert
        XCTAssertTrue(isEmpty)
    }
    
    func testIsBookStorageEmpty_whenBookStorageIsNotEmpty() async {
        // arrange
        mockFetchAllBooksUseCase.mockFetchAllBooksResult = [Book.mock()]
        
        // act
        let isNotEmpty = await viewModel.isBookStorageEmpty()
        
        // assert
        XCTAssertFalse(isNotEmpty)
    }
    
    func testProcessText_success() async {
        // arrange
        mockFetchBookInfoUseCase.mockFetchBookInfoResult = Book.mock()
        mockPersistBookInfoUseCase.mockPersistBookInfoResult = true
        let mockFilePath = URL(fileURLWithPath: "mockfile.txt")
        
        // act
        let result = await viewModel.processText(filePath: mockFilePath, filename: "mockfile.txt")
        
        // assert
        XCTAssertTrue(result)
        XCTAssertTrue(viewModel.showHistoryButton)
    }
    
    func testProcessText_failure_whenFetchBookInfoReturnsNil() async {
        // arrange
        mockFetchBookInfoUseCase.mockFetchBookInfoResult = nil
        let mockFilePath = URL(fileURLWithPath: "mockfile.txt")
        
        // act
        let result = await viewModel.processText(filePath: mockFilePath, filename: "mockfile.txt")
        
        // asset
        XCTAssertFalse(result)
    }
    
    func testProcessText_failure_when_FetchBookInfoAndProcessFileUseCasesReturnsNil() async {
        // arrange
        mockFetchBookInfoUseCase.mockFetchBookInfoResult = nil
        mockProcessFileUseCase.mockProcessFileResult = (false, nil)
        let mockFilePath = URL(fileURLWithPath: "mockfile.txt")
        
        // act
        let result = await viewModel.processText(filePath: mockFilePath, filename: "mockfile.txt")
        
        // assert
        XCTAssertFalse(result)
    }
    
    func testProcessText_success_when_FetchBookInfoIsNotNilAndProcessFileUseCaseIsNil() async {
        // arrange
        mockFetchBookInfoUseCase.mockFetchBookInfoResult = Book.mock()
        mockProcessFileUseCase.mockProcessFileResult = (false, nil)
        let mockFilePath = URL(fileURLWithPath: "mockfile.txt")
        
        // act
        let result = await viewModel.processText(filePath: mockFilePath, filename: "mockfile.txt")
        
        // assert
        XCTAssertTrue(result)
    }
    
    func testFetchFile_success() async {
        let mockFilePath = URL(fileURLWithPath: "mockfile.txt")
        mockFetchFileUseCase.mockFetchFileResult = (true, (mockFilePath, "mockfile.txt"))
        
        let result = await viewModel.fetchFile(at: "https://google.com/mockfile.txt")
        
        XCTAssertTrue(result != nil)
        XCTAssertTrue(viewModel.isButtonDisabled == false)
    }
    
    func testFetchFile_error() async {
        mockFetchFileUseCase.mockFetchFileResult = nil
        
        let result = await viewModel.fetchFile(at: "https://example.com/nonexistentfile.txt")
        
        XCTAssertTrue(result == nil)
    }
}

private class MockFetchFileUseCase: FetchFileUseCaseProtocol {
    var mockFetchFileResult: (Bool, FileDetails?)?
    
    func execute(with url: String, delegate: URLSessionDownloadDelegate) async throws -> (Bool, FileDetails?) {
        if let result = mockFetchFileResult {
            return result
        }
        return (false, nil)
    }
}

private class MockProcessFileUseCase: ProcessFileUseCaseProtocol {
    var mockProcessFileResult: (Bool, WordInfoDict?)?
    
    func execute(filePath: URL, fileName: String) async -> (Bool, WordInfoDict?) {
        if let result = mockProcessFileResult {
            return result
        }
        return (false, nil)
    }
}

private class MockPersistBookInfoUseCase: PersistBookInfoUseCaseProtocol {
    var mockPersistBookInfoResult: Bool = false
    
    func execute(url: String, bookInfo: Book) async -> Bool {
        return mockPersistBookInfoResult
    }
}

private class MockFetchBookInfoUseCase: FetchBookInfoUseCaseProtocol {
    var mockFetchBookInfoResult: Book?
    
    func execute(url: String) async -> Book? {
        return mockFetchBookInfoResult
    }
}

private class MockFetchAllBooksUseCase: FetchAllBooksUseCaseProtocol {
    var mockFetchAllBooksResult: [Book]?
    
    func execute() async -> [Book]? {
        return mockFetchAllBooksResult
    }
}

private extension Book {
    static func mock() -> Book {
        return Book(fileName: "", date: Date(), url: "", info: ["mock": WordInfo.mock()])
    }
}
