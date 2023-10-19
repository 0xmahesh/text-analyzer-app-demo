//
//  FetchAllBooksUseCaseProtocol.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-18.
//

import Foundation

protocol FetchAllBooksUseCaseProtocol {
    func execute() async -> [Book]?
}
