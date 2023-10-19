//
//  ScrabbleScorer.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation
import UIKit

struct ScrabbleAlphabet: ScrabbleAlphabetConfigurable {
    var language: ScrabbleLanguages
    var allowedCodePoints: Set<Int>
    var letterScores: [Int: Int]
}

actor ScrabbleWordScorer: ScrabbleWordScorable {
    
    private var alphabet: ScrabbleAlphabetConfigurable
    private var scalarValueScores: [Int: Int] = [:]
    
    init(alphabet: ScrabbleAlphabetConfigurable) {
        self.alphabet = alphabet
  
        for(codePoint, score) in alphabet.letterScores {
            if alphabet.allowedCodePoints.contains(codePoint) {
                self.scalarValueScores[codePoint] = score
            }
        }
    }
    
    func calculateScore(for word: String) async -> Int {
        if word.count > 15 {
            return 0
        }
        
        let uppercaseWord = word.uppercased()
        var score = 0
        
        if word.isValidWord(in: alphabet.language.rawValue, withAllowedCodePoints: alphabet.allowedCodePoints) && !word.containsDiacriticOrNonAlphabetic {
            for char in uppercaseWord {
                if let unicodeScalar = char.unicodeScalars.first,
                   let charScore = scalarValueScores[Int(unicodeScalar.value)] {
                    score += charScore
                }
            }
        }
        
        return score
    }
}

private extension String {
    static let textChecker = UITextChecker()
    
    func isValidCharacter(_ char: Character, withAllowedCodePoints allowedCodePoints: Set<Int>) -> Bool {
        if let unicodeScalar = char.unicodeScalars.first {
            return allowedCodePoints.contains(Int(unicodeScalar.value))
        }
        return false
    }
    
    func isValidWord(in language: String, withAllowedCodePoints allowedCodePoints: Set<Int>) -> Bool {
        for char in self {
            if !isValidCharacter(char, withAllowedCodePoints: allowedCodePoints) {
                return false
            }
        }
        // might slow down performance a tad, but helpful to filter valid words. open for discussion.
        let misspelledRange = String.textChecker.rangeOfMisspelledWord(in: self, range: NSRange(0..<self.utf16.count), startingAt: 0, wrap: false, language: language)
        
        return misspelledRange.location == NSNotFound
    }
    
    var containsDiacriticOrNonAlphabetic: Bool {
        if let string = self as NSString? {
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
}


