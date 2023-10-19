//
//  FileRepositoryTests.swift
//  BookReaderAppTests
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import XCTest
@testable import BookReaderApp

class FileRepositoryTests: XCTestCase {
    private var fileRepository: FileRepository!
    private var mockNetworkClient: MockFileDownloaderProtocol!
    private var mockFileManager: MockFileManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkClient = MockFileDownloaderProtocol()
        mockFileManager = MockFileManager()
        fileRepository = FileRepository(networkClient: mockNetworkClient, fileManager: mockFileManager)
    }
    
    override func tearDown() {
        fileRepository = nil
        mockNetworkClient = nil
        mockFileManager = nil
        super.tearDown()
    }
    
    func testFetchLocalFile_whenFileExists() async {
        let tempDir = FileManager.default.temporaryDirectory
        let mockURL = tempDir.appendingPathComponent("mockfile.txt")
        
        mockFileManager.mockFileExistsResult = true
        mockFileManager.mockDocumentDirectoryURL = tempDir
        
        let result = await fileRepository.fetchLocalFile(url: mockURL.absoluteString)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0, mockURL)
        XCTAssertEqual(result?.1, "mockfile.txt")
    }
    
    func testFetchLocalFile_whenFileIsNonExistent() async {
        mockFileManager.mockFileExistsResult = false
        
        let result = await fileRepository.fetchLocalFile(url: "/nonexistentfile.txt")
        
        XCTAssertNil(result)
    }
    
    func testFetchRemoteFile() async throws {
        let expectedURL = "https://google.com/remotefile.txt"
        
        try await fileRepository.fetchRemoteFile(url: expectedURL, delegate: nil)
        
        XCTAssertEqual(mockNetworkClient.capturedURL, expectedURL)
        XCTAssertTrue(mockNetworkClient.delegate === nil)
    }
}

private class MockFileDownloaderProtocol: FileDownloaderProtocol {
    var delegate: URLSessionDownloadDelegate?
    var capturedURL: String = ""
    
    func downloadFile(at url: String) async throws {
        capturedURL = url
    }
}

private class MockFileManager: FileManager {
    var mockFileExistsResult = false
    var mockDocumentDirectoryURL: URL?
    
    override func fileExists(atPath path: String) -> Bool {
        return mockFileExistsResult
    }
    
    override func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        if let mockDocumentDirectoryURL = mockDocumentDirectoryURL {
            return [mockDocumentDirectoryURL]
        }
        return []
    }
}
