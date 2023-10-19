//
//  FileRepository.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation

final class FileRepository: FileRepositoryProtocol {
    
    private var networkClient: FileDownloaderProtocol
    private var fileManager: FileManager
    
    init(networkClient: FileDownloaderProtocol,fileManager: FileManager = .default) {
        self.networkClient = networkClient
        self.fileManager = fileManager
    }
    
    func fetchLocalFile(url: String) async -> (URL, String)? {
        if let fileName = URL(string: url)?.lastPathComponent {
            if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let destinationUrl = documentsURL.appendingPathComponent(fileName)
                if fileManager.fileExists(atPath: destinationUrl.path) {
                    return (destinationUrl, fileName)
                }
            }
        }
        return nil
    }
    
    func fetchRemoteFile(url: String, delegate: URLSessionDownloadDelegate?) async throws {
        networkClient.delegate = delegate
        try await networkClient.downloadFile(at: url)
    }
}
