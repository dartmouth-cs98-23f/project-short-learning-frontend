//
//  ErrorView.swift
//  Discite
//
//  Created by Jessie Li on 3/3/24.
//

import SwiftUI

struct ErrorView: View {
    var text: String

    var body: some View {
        Text(text)
            .foregroundStyle(Color.pink)
            .containerRelativeFrame([.horizontal, .vertical])
    }
}

#Preview {
    ErrorView(text: "Error loading content.")
}
