//
//  SearchViewModel.swift
//  Discite
//
//  Created by Bansharee Ireen on 2/12/24.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchHistory: [String] = []
    
    // get search suggestions based on current text
    func getSuggestions(for text: String) -> [String] {
        return ["Suggestion 1", "Suggestion 2", "Suggestion 3"]
    }
    
    // perform search
    func performSearch() {
        // search logic here
    }
}
