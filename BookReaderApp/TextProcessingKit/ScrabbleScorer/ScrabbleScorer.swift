//
//  ScrabbleScorer.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation
import UIKit

actor ScrabbleWordScorer: ScrabbleWordScorable {
    
    internal var letterScores: [Character: Int] = [
        "A": 1, "E": 1, "I": 1, "O": 1, "U": 1, "L": 1, "N": 1, "R": 1, "S": 1, "T": 1,
        "D": 2, "G": 2,
        "B": 3, "C": 3, "M": 3, "P": 3,
        "F": 4, "H": 4, "V": 4, "W": 4, "Y": 4,
        "K": 5,
        "J": 8, "X": 8,
        "Q": 10, "Z": 10
    ]
    
    func calculateScore(for word: String) async -> Int {
        
        if word.count > 15 {
            return 0
        }
        
        let uppercaseWord = word.uppercased()
        var score = 0
        
        if word.isValidWord && !word.containsDiacriticOrNonAlphabetic {
            for letter in uppercaseWord {
                if let letterScore = letterScores[letter] {
                    score += letterScore
                }
            }
        }
        
        return score
    }
}

private extension String {
    static let textChecker = UITextChecker()
    
    var containsDiacriticOrNonAlphabetic: Bool {
        if let string = self as NSString? {
            // Check for diacritic accents
            let folded = string.folding(options: .diacriticInsensitive, locale: nil)
            if folded != self {
                return true
            }
        }
        
        for char in self {
            if !char.isLetter {
                return true
            }
        }
        return false
    }
    
    var isValidWord: Bool {
        // might slow down the operations a tad. open for discussion.
        let misspelledRange = String.textChecker.rangeOfMisspelledWord(in: self, range: NSRange(0..<self.utf16.count), startingAt: 0, wrap: false, language: "en_US")
        return misspelledRange.location == NSNotFound
    }
}
