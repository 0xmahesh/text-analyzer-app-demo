//
//  FileRepositoryProtocol.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation

protocol FileRepositoryProtocol {
    func fetchLocalFile(url: String) async -> (URL, String)?
    func fetchRemoteFile(url: String, delegate: URLSessionDownloadDelegate?) async throws
}
