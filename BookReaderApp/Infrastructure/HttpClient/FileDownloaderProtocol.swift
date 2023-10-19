//
//  FileDownloaderProtocol.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import Foundation

protocol FileDownloaderProtocol {
    var delegate: URLSessionDownloadDelegate? { get set }
    func downloadFile(at url: String) async throws
}
