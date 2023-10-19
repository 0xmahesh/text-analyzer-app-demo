//
//  PillShapedButtonView.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-18.
//

import Foundation
import SwiftUI

struct PillShapedButtonView: View {
    private let title: String
    
    init(withTitle title: String) {
        self.title = title
    }
    var body: some View {
        VStack {
            Text(title)
        }
        .frame(minWidth: 200, minHeight: 44)
        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .stroke(Color.blue, lineWidth: 1)
        )
    }
}
