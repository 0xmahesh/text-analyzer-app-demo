//
//  WordProcessable.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation

protocol WordProcessable {
    func countWords(in line: String) async throws
    func getWordDictionary() async -> WordInfoDict
    func sanitizeWord(_ word: String) -> String
}
