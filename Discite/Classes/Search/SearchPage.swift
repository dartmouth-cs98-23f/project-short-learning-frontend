//
//  SearchPage.swift
//  Discite
//
//  Created by Jessie Li on 2/10/24.
//

import SwiftUI

struct SearchPage: View {
    // Get search items, search suggestions, recent from api
    let names = ["Holly", "Josh Holly", "Rhonda", "Ted"]
    @State private var searchText = ""
    @State var searchActive: Bool = false
  
    // When click on navigation link, need to set search query
        var body: some View {
            VStack {
                // CustomSearchBar(searchText: $searchText, active: $active)
                
                NavigationStack {
                    SearchedView(searchText: searchText)
                        .searchable(text: $searchText)
                        .navigationTitle("Explore")
                        .border(.pink)
                    
                    Text("placeholder")
                }
            }
            .padding(.horizontal, 18)
    
        }

        var searchResults: [String] {
            if searchText.isEmpty {
                return names
            } else {
                return names.filter { $0.contains(searchText) }
            }
        }
    
    func recentSearchs() -> some View {
        VStack(alignment: .leading) {
            Text("Recent")
                .font(.H5)
            
            List {
                NavigationLink {
                    SearchResultsPage(searchQuery: "javascript")
                        .onAppear {
                            searchText = "javascript"
                        }
                } label: {
                    Text("javascript")
                }
                .listRowInsets(EdgeInsets())
                
                NavigationLink {
                    SearchResultsPage(searchQuery: "machine learning")
                } label: {
                    Text("machine learning")
                }
                .listRowInsets(EdgeInsets())
                
                NavigationLink {
                    SearchResultsPage(searchQuery: "rest apis")
                } label: {
                    Text("rest apis")
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
        }
    }
}

private struct SearchedView: View {
    let searchText: String
    let items = ["javascript", "machine learning", "apis"]
    var filteredItems: [String] { items.filter { $0.contains(searchText.lowercased()) } }

    @State private var isPresented = false
    @Environment(\.isSearching) private var isSearching
    
    var body: some View {
        if isSearching {
            List {
                ForEach(filteredItems, id: \.self) { name in
                    NavigationLink {
                        SearchResultsPage(searchQuery: name)

                    } label: {
                        Text(name)
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .listStyle(.plain)
        } else {
            
        }
    }
}

#Preview {
    SearchPage()
}
