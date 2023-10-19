//
//  Book.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation

struct Book: Codable, Identifiable {
    var id: UUID = UUID()
    let fileName: String
    let date: Date
    let url: String
    let info: WordInfoDict
}
