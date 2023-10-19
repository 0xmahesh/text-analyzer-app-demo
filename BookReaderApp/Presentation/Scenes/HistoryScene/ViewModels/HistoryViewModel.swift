//
//  HistoryViewModel.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-18.
//

import Foundation

final class HistoryViewModel: NSObject, ObservableObject {
    @Published var books: [Book] = []
    private var fetchAllBooksUseCase: FetchAllBooksUseCaseProtocol?
    
    init(fetchAllBooksUseCase: FetchAllBooksUseCaseProtocol) {
        self.fetchAllBooksUseCase = fetchAllBooksUseCase
    }
    
    @MainActor
    func loadData() async {
        books = await fetchAllBooksUseCase?.execute() ?? []
    }
}
