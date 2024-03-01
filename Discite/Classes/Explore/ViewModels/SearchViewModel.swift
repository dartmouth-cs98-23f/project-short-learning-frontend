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
    @Binding var history: [String]
    @Published var shouldNavigate = false
    @Published var searchables: [Searchable] = []
    
    init(history: Binding<[String]>) {
        _history = history
    }
    
    // load persistent history into var
    func loadHistory(historyFromStore: [String]) {
        self.history = historyFromStore
        print("loading from store into searchViewModel")
        print(historyFromStore)
    }
    
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

                ForEach(history.reversed(), id: \.self) { searchItem in
                    NavigationLink(destination: {
                        SearchDestinationView(history: self.$history, searchText: searchItem, searchables: self.searchables)
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
                        SearchDestinationView(history: self.$history, searchText: suggestion.name, searchables: self.searchables)
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
