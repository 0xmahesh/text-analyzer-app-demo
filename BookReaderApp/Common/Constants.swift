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
    
    static let englishAlphabetLetterScores = [
        65: 1, 66: 3, 67: 3, 68: 2, 69: 1, 70: 4, 71: 2, 72: 4, 73: 1, 74: 8,
        75: 5, 76: 1, 77: 3, 78: 1, 79: 1, 80: 3, 81: 10, 82: 1, 83: 1, 84: 1,
        85: 1, 86: 4, 87: 4, 88: 8, 89: 4, 90: 10
    ]
    
    static let chineseAlphabetLetterScores = [
        19968: 1, 19969 : 2, 19971: 3, 19975: 4
    ]
    
    static let englishAlphabetCodePoints = Set(65...90).union(97...122)
    static let chineseAlphabetCodePoints = Set(19968...40959)
}
