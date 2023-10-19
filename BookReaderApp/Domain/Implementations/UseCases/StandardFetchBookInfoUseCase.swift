//
//  StandardFetchBookInfoUseCase.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import Foundation

final class StandardFetchBookInfoUseCase: FetchBookInfoUseCaseProtocol {
    
    private let storage: DictionaryStorage<Book>
    
    init(storage: DictionaryStorage<Book>) {
        self.storage = storage
    }
    
    func execute(url: String) async -> Book? {
        do {
            return try await storage.getDictionary(forKey: url)
        } catch {
            return nil
        }
    }
}
