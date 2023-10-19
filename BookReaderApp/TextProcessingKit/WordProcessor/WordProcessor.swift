//
//  WordProcessor.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation

actor WordProcessor: WordProcessable {
    
    private(set) var wordFrequencyDictionary: WordInfoDict
    private let scrabbleWordScorer: ScrabbleWordScorable
    private let wordExtractionRegexPattern: String
    
    init(wordFrequencyDictionary: WordInfoDict = [:],
         scrabbleWordScorer: ScrabbleWordScorable,
         wordExtractionRegexPattern: String) {
        self.wordFrequencyDictionary = wordFrequencyDictionary
        self.scrabbleWordScorer = scrabbleWordScorer
        self.wordExtractionRegexPattern = wordExtractionRegexPattern
    }
    
    func countWords(in line: String) async throws {
        let words = try await extractWords(line)
        
        for word in words {
            let sanitizedWord = sanitizeWord(word)
            if !sanitizedWord.isEmpty {
                if var wordInfo = wordFrequencyDictionary[sanitizedWord] {
                    wordInfo.frequency += 1
                    wordFrequencyDictionary[sanitizedWord] = wordInfo
                } else {
                    wordFrequencyDictionary[sanitizedWord] = await WordInfo(word: sanitizedWord, frequency: 1, scrabbleScore: scrabbleWordScorer.calculateScore(for: sanitizedWord))
                }
            }
        }
    }
    
    func getWordDictionary() async -> WordInfoDict {
        return wordFrequencyDictionary
    }
    
    private func extractWords(_ line: String) async throws -> [String] {
        let regex = try NSRegularExpression(pattern: wordExtractionRegexPattern, options: [])
        let matches = regex.matches(in: line, options: [], range: NSRange(line.startIndex..., in: line))
        return matches.compactMap { match in
            if let range = Range(match.range(at:1), in: line) {
                return String(line[range])
            } else {
                return nil
            }
        }
    }
    
    nonisolated func sanitizeWord(_ word: String) -> String {
        return word
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: .punctuationCharacters)
    }
}
