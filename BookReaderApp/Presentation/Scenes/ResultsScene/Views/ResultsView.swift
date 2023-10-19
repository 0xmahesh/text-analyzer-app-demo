//
//  ResultsView.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-17.
//

import Foundation
import SwiftUI

struct ResultsView: View {
    @StateObject private var viewModel: ResultsViewModel

    init(viewModel: ResultsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                if let fileName = viewModel.fileName {
                    CardView {
                        TitleView(fileName: fileName)
                            .frame(maxHeight: 44)
                    }
                    .padding()
                }
                
                if let mostFrequentWord = viewModel.mostFrequentWord {
                    CardView {
                        Text("The most frequent word is **\(mostFrequentWord.word)**. It appeared **\(mostFrequentWord.frequency)** times.")
                    }
                    .padding()
                }
                
                if let mostFrequentSevenCharWord = viewModel.mostFrequentSevenCharWord {
                    CardView {
                        Text("The most frequent 7-character word is **\(mostFrequentSevenCharWord.word)**, and it appeared **\(mostFrequentSevenCharWord.frequency)** times.")
                    }
                    .padding()
                }
                
                if let scrabbleScores = viewModel.scrabbleScores {
                    CardView {
                        ScrabbleScoresListView(scrabbleScores: scrabbleScores)
                    }
                    .padding()
                }
                
            }
        }
        .navigationTitle("Summary")
    }
}

private struct TitleView: View {
    var fileName: String

    var body: some View {
        Text("File name: **\(fileName)**" )
            .font(.subheadline)
            .padding()
    }
}
