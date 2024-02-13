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
    @Published var shouldNavigate = false
    
    // get search suggestions based on current text
    func getSuggestions(for text: String) -> [String] {
        let predefinedSuggestions = ["Apple Pie", "Apple Juice", "Banana Bread", "Banana Smoothie", "Orange Juice", "Orange Chicken"]
        let filteredSuggestions = predefinedSuggestions.filter { $0.lowercased().contains(text.lowercased()) }

        return filteredSuggestions
    }
    
    // perform search
    func performSearch() {
        // Set shouldNavigate to true to trigger navigation
        shouldNavigate = true
    }
    
    func DestinationView() -> some View {
        Text("Search Text: \(searchText)")
    }

    //*** displaying search-related stuff below***
    func showSearchHistory() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Search History")
                .font(Font.caption)
                .foregroundColor(.gray)
                .padding(.leading, 16)
            
            Divider()

            ForEach(searchHistory.reversed(), id: \.self) { searchItem in
                NavigationLink(destination: {
                    SearchDestinationView(searchText: searchItem)
                }, label: {
                    Text(searchItem)
                    .font(Font.body)
                    .padding(.horizontal, 16)
                })
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
                NavigationLink(destination: {
                    SearchDestinationView(searchText: suggestion)
                }, label: {
                    Text(suggestion)
                    .font(Font.body)
                    .padding(.horizontal, 16)
                    .frame(alignment: .leading)
                })
            }

            Spacer()
        }
    }
}
