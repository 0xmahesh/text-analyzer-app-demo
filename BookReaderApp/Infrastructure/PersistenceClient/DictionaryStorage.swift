//
//  DictionaryStorage.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation

protocol DictionaryStorageProtocol {
    associatedtype Value
    func saveDictionary(_ dictionary: Value, forKey key: String) async throws
    func getDictionary(forKey key: String) async throws -> Value?
    func fetchAllDictionaries() throws -> [Value]?
}


final class DictionaryStorage<Value: Codable>: DictionaryStorageProtocol {
    private let storageUrl: URL
    
    init(storageUrl: URL) {
        self.storageUrl = storageUrl
        do {
            try loadStorage()
        } catch {
            storage = [:]
        }
    }

    private var storage: [String: Value]?

    private func saveStorage() throws {
        let data = try JSONEncoder().encode(storage)
        try data.write(to: storageUrl)
    }

    private func loadStorage() throws {
        do {
            let data = try Data(contentsOf: storageUrl)
            let loadedStorage = try JSONDecoder().decode([String: Value].self, from: data)
            storage = loadedStorage
        } catch {
            storage = [:]
        }
    }

    func saveDictionary(_ dictionary: Value, forKey key: String) async throws {
        storage?[key] = dictionary
        try saveStorage()
    }

    func getDictionary(forKey key: String) async throws -> Value? {
        if storage == nil {
            try loadStorage()
        }
        return storage?[key]
    }
    
    func fetchAllDictionaries() throws -> [Value]? {
        if storage == nil {
            try loadStorage()
        }
        return storage?.map { $0.value }
    }
}
