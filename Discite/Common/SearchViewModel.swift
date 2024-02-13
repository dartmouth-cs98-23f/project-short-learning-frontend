//
//  SearchViewModel.swift
//  Discite
//
//  Created by Bansharee Ireen on 2/12/24.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var isFocused = false
    @Published var searchHistory: [String] = ["clowns", "buffalos"]
    
    // get search suggestions based on current text
    func getSuggestions(for text: String) -> [String] {
        return ["Suggestion 1", "Suggestion 2", "Suggestion 3"]
    }
    
    // perform search
    func performSearch() {
        // search logic here
        Spacer()
    }
    
    func showSearchHistory() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent Searches")
                .font(Font.caption)
                .foregroundColor(.gray)
                .padding(.leading, 16)
            
            ForEach(searchHistory, id: \.self) { searchItem in
                Text(searchItem)
                    .font(Font.body)
                    .padding(.horizontal, 16)
            }

            Spacer()
        }
    }
    
    func showSuggestions() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Search Suggestions")
                .font(Font.caption)
                .foregroundColor(.gray)
                .padding(.leading, 16)
                .frame(alignment: .leading)
            
            ForEach(self.getSuggestions(for: searchText), id: \.self) { suggestion in
                Text(suggestion)
                    .font(Font.body)
                    .padding(.horizontal, 16)
                    .frame(alignment: .leading)
            }

            Spacer()
        }
    }
}
