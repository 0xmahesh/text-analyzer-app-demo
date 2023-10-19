//
//  StandardFetchAllBooksUseCase.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-18.
//

import Foundation

final class StandardFetchAllBooksUseCase: FetchAllBooksUseCaseProtocol {
    
    private let storage: DictionaryStorage<Book>
    
    init(storage: DictionaryStorage<Book>) {
        self.storage = storage
    }
    
    func execute() async -> [Book]? {
        do {
            return try storage.fetchAllDictionaries()
        } catch {
            return nil
        }
    }
}
