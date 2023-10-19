//
//  FileHandlerProtocol.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import Foundation

typealias WordInfoDict = [String: WordInfo]

protocol FileHandlerProtocol {
    func processTextFile(at filePath: URL, filename: String) async -> (Bool, WordInfoDict?)
}
