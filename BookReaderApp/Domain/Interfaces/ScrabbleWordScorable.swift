//
//  ScrabbleWordScorable.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import Foundation

protocol ScrabbleWordScorable {
    func calculateScore(for word: String) async -> Int
}
