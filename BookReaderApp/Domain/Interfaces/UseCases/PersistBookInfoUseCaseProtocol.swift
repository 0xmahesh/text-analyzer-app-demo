//
//  PersistBookInfoUseCaseProtocol.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation

protocol PersistBookInfoUseCaseProtocol {
    func execute(url: String, bookInfo: Book) async -> Bool
}
