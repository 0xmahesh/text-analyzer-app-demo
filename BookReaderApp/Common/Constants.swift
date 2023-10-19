//
//  Constants.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import Foundation

struct Constants {
    static let storageFileName: String = "dictionaryStorage.json"
    static let wordExtractionRegexPattern = #"(\b\w+\b)(\p{P}*)"#
}
