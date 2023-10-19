//
//  HistoryListItemView.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-18.
//

import Foundation
import SwiftUI

struct HistoryListItemView: View {
    let book: Book
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(UIColor.systemBackground))
            .overlay(
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(book.fileName)")
                        .font(.subheadline)
                        .bold()
                    Text("\(book.url)")
                        .font(.subheadline)
                    Text("Processed on: \(book.date.toDateString)")
                        .font(.caption)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }
                .padding()
            )
    }
}


private extension Date {
    var toDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm"
        return dateFormatter.string(from: self)
    }
}
