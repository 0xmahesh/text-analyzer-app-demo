//
//  FileDownloaderTests.swift
//  BookReaderAppTests
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import XCTest
@testable import BookReaderApp

class FileDownloaderTests: XCTestCase {
    var fileDownloader: FileDownloader!

    override func setUp() {
        super.setUp()

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]

        fileDownloader = FileDownloader(configuration: configuration)
    }

    override func tearDown() {
       // fileDownloader = nil
        super.tearDown()
    }

    func testDownloadFileWithValidUrl_isSuccessful() async throws {
        // arrange
        let validURL = "https://google.com/validfile.txt"
        let expectation = XCTestExpectation(description: "Download should complete successfully")
        let expectedResponse = HTTPURLResponse(url: URL(string: validURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let expectedData = "This is a valid file.".data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            return (expectedResponse, expectedData)
        }
        
        let downloadDelegate = MockDownloadDelegate { url, response, error in
            // assert
            XCTAssertNil(error)
            XCTAssertNotNil(url)
            XCTAssertNotNil(response)
            expectation.fulfill()
        }
        
        fileDownloader.delegate = downloadDelegate
        


        // act
        try await fileDownloader.downloadFile(at: validURL)

        await fulfillment(of: [expectation], timeout: 10)
    }

    func testDownloadFileWithInvalidURL() async throws {
        // arrange
        let invalidUrl = "http://invalid"
        let expectation = XCTestExpectation(description: "Download should complete with error.")
        
        MockURLProtocol.requestHandler = { request in
            throw URLError(.unknown)
        }
        
        let downloadDelegate = MockDownloadDelegate { url, response, error in
            // assert
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        fileDownloader.delegate = downloadDelegate
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Task {
                try await self.fileDownloader.downloadFile(at: invalidUrl)
            }
        }
    }
}

private class MockDownloadDelegate: NSObject, URLSessionDownloadDelegate {
    let completion: (URL?, URLResponse?, Error?) -> Void

    init(completion: @escaping (URL?, URLResponse?, Error?) -> Void) {
        self.completion = completion
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        completion(location, downloadTask.response, nil)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            completion(nil, task.response, error)
        }
    }
    
    
}

private class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
          }
            
          do {
            let (response, data) = try handler(request)
              
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = data {
              client?.urlProtocol(self, didLoad: data)
            }
            
            client?.urlProtocolDidFinishLoading(self)
          } catch {
            client?.urlProtocol(self, didFailWithError: error)
          }
    }
    
    override func stopLoading() {}
}
