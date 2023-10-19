//
//  ProcessFileUseCaseProtocol.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import Foundation

protocol ProcessFileUseCaseProtocol {
    func execute(filePath: URL, fileName: String) async -> (Bool, WordInfoDict?)
}
