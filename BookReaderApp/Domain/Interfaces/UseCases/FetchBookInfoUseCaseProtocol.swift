//
//  FetchBookInfoUseCaseProtocol.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation

protocol FetchBookInfoUseCaseProtocol {
    func execute(url: String) async -> Book?
}
