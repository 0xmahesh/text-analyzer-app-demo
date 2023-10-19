//
//  HistoryView.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-18.
//

import Foundation
import SwiftUI

struct HistoryView: View {
    private let dependencyProvider: AppDIContainer
    
    @StateObject private var viewModel: HistoryViewModel
    @State private var isLinkActive = false
    
    init(dependencyProvider: AppDIContainer) {
        self.dependencyProvider = dependencyProvider
        _viewModel = StateObject(wrappedValue: dependencyProvider.makeHistoryViewModel())
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.books) { book in
                NavigationLink(destination: ResultsView(dependencyProvider: dependencyProvider, url: book.url), label: {
                    HistoryListItemView(book: book)
                        .frame(minHeight: 80)
                })
            }
            .onAppear {
                Task {
                    await viewModel.loadData()
                }
            }
            .navigationTitle("History")
        }
        
    }
}

