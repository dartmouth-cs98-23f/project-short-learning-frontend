//
//  TestView.swift
//  Discite
//
//  Created by Jessie Li on 3/4/24.
//

import SwiftUI

enum FruitToken: Hashable, Identifiable, CaseIterable {
    case apple
    case pear
    case banana

    var id: Self { self }
}

struct TestView: View {
    @State private var text = ""
    @State private var tokens: [FruitToken] = []

    var body: some View {
        
        NavigationStack {
            EmptyView()
                .searchable(text: $text, tokens: $tokens) { token in
                    switch token {
                    case .apple: Text("Apple")
                    case .pear: Text("Pear")
                    case .banana: Text("Banana")
                    }
                }
                .searchSuggestions {
                    Text("🍎").searchCompletion(FruitToken.apple)
                    Text("🍐").searchCompletion(FruitToken.pear)
                    Text("🍌").searchCompletion(FruitToken.banana)
                }
            }
        }
}

#Preview {
    TestView()
}
