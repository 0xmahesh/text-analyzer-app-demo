//
//  ScrabbleWordScorable.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import Foundation

enum ScrabbleLanguages: String {
    case english = "en_US"
    case chinese = "zh_CN"
}

protocol ScrabbleWordScorable {
    func calculateScore(for word: String) async -> Int
}

protocol ScrabbleAlphabetConfigurable {
    var language: ScrabbleLanguages { get set }
    var allowedCodePoints: Set<Int> { get set }
    var letterScores: [Int: Int] { get set }
}
