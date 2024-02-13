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
        return ["sugg 1", "sugg 2", "sugg 3"]
    }
    
    // perform search
    func performSearch() {
        // search logic here
        Spacer()
    }
    
    //*** displaying search-related stuff below***
    func showSearchHistory() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Search History")
                .font(Font.caption)
                .foregroundColor(.gray)
                .padding(.leading, 16)
            
            Divider()

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
            Text("Suggestions")
                .font(Font.caption)
                .foregroundColor(.gray)
                .padding(.leading, 16)
                .frame(alignment: .leading)
            
            Divider()

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
