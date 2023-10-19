//
//  Extensions.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation

extension FileManager {
    func dictionaryStorageUrl(for fileName: String) -> URL {
        return self.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
    }
}
