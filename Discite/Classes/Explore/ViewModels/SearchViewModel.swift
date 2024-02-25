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
    @Published var searchHistory: [String] = ["Internet", "Algorithms"]
    @Published var shouldNavigate = false
    @Published var searchables: [Searchable] = []
    
    // get search suggestions based on current text
    func getSuggestions(for text: String) -> [Searchable] {
        let predefinedSuggestions = searchables
        let filteredSuggestions = predefinedSuggestions.filter { $0.name.lowercased().contains(text.lowercased()) }

        return filteredSuggestions
    }
    
    // perform search
    func performSearch() {
        // Set shouldNavigate to true to trigger navigation
        shouldNavigate = true
    }

    // *** displaying search-related stuff below ***
    func showSearchHistory() -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Search History")
                    .font(Font.caption)
                    .foregroundColor(.gray)
                    .padding(.leading, 16)
                
                Divider()

                ForEach(searchHistory.reversed(), id: \.self) { searchItem in
                    NavigationLink(destination: {
                        SearchDestinationView(searchText: searchItem, searchables: self.searchables)
                    }, label: {
                        Text(searchItem)
                        .font(Font.body)
                        .padding(.horizontal, 16)
                    })
                }
            }
        }
    }
    
    func showSuggestions() -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Suggestions")
                    .font(Font.caption)
                    .foregroundColor(.gray)
                    .padding(.leading, 16)
                    .frame(alignment: .leading)
                
                Divider()

                ForEach(self.getSuggestions(for: searchText), id: \.id) { suggestion in
                    NavigationLink(destination: {
                        SearchDestinationView(searchText: suggestion.name, searchables: self.searchables)
                    }, label: {
                        Text(suggestion.name)
                            .font(Font.body)
                            .padding(.horizontal, 16)
                            .frame(alignment: .leading)
                    })
                }
            }
        }
    }
}
