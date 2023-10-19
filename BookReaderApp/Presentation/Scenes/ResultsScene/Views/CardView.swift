//
//  CardView.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-18.
//

import Foundation
import SwiftUI

struct CardView<Content: View>: View {
    @ViewBuilder
    private let content: Content

    public init(
        @ViewBuilder contentBuilder: @escaping () -> Content
    ) {
        content = contentBuilder()
    }

    public var body: some View {
        VStack(alignment: .leading) {
            content
                .padding(20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.yellow).opacity(0.3))
                .shadow(color: Color(.systemGray).opacity(0.3), radius: 3, y: 3)
        )
    }
}
