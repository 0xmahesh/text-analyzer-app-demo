//
//  ScrabbleScoreView.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-18.
//

import Foundation
import SwiftUI

struct ScrabbleScoreView: View {
    let word: String
    let score: Int

    var body: some View {
        HStack {
            Text(word)
                .fixedSize()
                .foregroundColor(.primary)
                .font(.headline)
            Spacer()
            Text(score.description)
                .foregroundColor(.primary)
                .font(.headline)
        }
        .frame(height: 40)
    }
}

struct ScrabbleScoresListView: View {
    var scrabbleScores: [WordInfo]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Highest scoring 100 words according to Scrabble distribution table:")
            HStack {
                Text("Word")
                    .bold()
                Spacer()
                Text("Score")
                    .bold()
                
            }
            .padding([.leading, .trailing], 20)
            List {
                ForEach(scrabbleScores) { score in
                    ScrabbleScoreView(word: score.word, score: score.scrabbleScore)
                    
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.clear)
                )
            .listStyle(PlainListStyle())
            .frame(height: scrabbleScores.count > 10 ? 400 : 40 * CGFloat((scrabbleScores.count+2)))
            Spacer()
        }
    }
}
