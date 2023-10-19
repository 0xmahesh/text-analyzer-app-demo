//
//  WordInfo.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation

struct WordInfo: Codable, Comparable, Identifiable {
    var id: UUID = UUID()
    var word: String
    var frequency: Int = 0
    var scrabbleScore: Int = 0
    
    static func < (lhs: WordInfo, rhs: WordInfo) -> Bool {
        return lhs.frequency < rhs.frequency
    }
}
