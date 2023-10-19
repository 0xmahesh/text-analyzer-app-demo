//
//  StandardPersistBookInfoUseCase.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation

final class StandardPersistBookInfoUseCase: PersistBookInfoUseCaseProtocol {
    
    private let storage:  DictionaryStorage<Book>
    
    init(storage: DictionaryStorage<Book>) {
        self.storage = storage
    }
    
    func execute(url: String, bookInfo: Book) async -> Bool {
        do {
            try await storage.saveDictionary(bookInfo, forKey: url)
            return true
        } catch {
            return false
        }
    }
 
}
