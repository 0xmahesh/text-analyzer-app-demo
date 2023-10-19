//
//  NetworkErrors.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import Foundation

enum NetworkErrors: Error {
    case invalidUrl
}

final class FileDownloader: FileDownloaderProtocol {
    var delegate: URLSessionDownloadDelegate?
    
    func downloadFile(at url: String) async throws {
        
    }
    
}
