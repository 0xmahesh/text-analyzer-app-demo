//
//  FileDownloader.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import Foundation

final class FileDownloader: FileDownloaderProtocol {
    var delegate: URLSessionDownloadDelegate?
    private let configuration: URLSessionConfiguration
    
    init(configuration: URLSessionConfiguration = .default, delegate: URLSessionDownloadDelegate? = nil) {
        self.delegate = delegate
        self.configuration = configuration
    }
    
    func downloadFile(at url: String) async throws  {
        if let url = URL(string: url) {
            let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
            let task = session.downloadTask(with: url)
            task.resume()
        } else {
            throw NetworkErrors.invalidUrl
        }
    }
    
}
