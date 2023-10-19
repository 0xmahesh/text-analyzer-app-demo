//
//  FetchFileUseCaseProtocol.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import Foundation

protocol FetchFileUseCaseProtocol {
    func execute(with url: String, delegate: URLSessionDownloadDelegate) async throws -> (Bool, FileDetails?)
}
