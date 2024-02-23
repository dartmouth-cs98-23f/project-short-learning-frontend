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
    @StateObject var exploreViewModel = ExploreViewModel()
    
    // combine topics and recommendations
    func createSearchables() -> [Searchable] {
        var searchables: [Searchable] = []
        
        // add topic recommendations
        for topic in exploreViewModel.topicRecommendations {
            let searchable = Searchable(id: topic.id.uuidString, name: topic.topicName, type: .topic, topic: topic, playlist: nil)
            searchables.append(searchable)
            print("topic loop")
        }
        
        // add playlist recommendations
        if let playlists = exploreViewModel.playlistRecommendations {
            for playlist in playlists {
                let searchable = Searchable(id: playlist.id.uuidString, name: playlist.title, type: .playlist, topic: nil, playlist: playlist)
                searchables.append(searchable)
            }
        }

        print("Searchables: \(searchables)")
        
        return searchables
    }
    
    // get search suggestions based on current text
    func getSuggestions(for text: String) -> [Searchable] {
        let predefinedSuggestions = createSearchables()
        let filteredSuggestions = predefinedSuggestions.filter { $0.name.lowercased().contains(text.lowercased()) }

        return filteredSuggestions
    }
    
    // perform search
    func performSearch() {
        // Set shouldNavigate to true to trigger navigation
        shouldNavigate = true
    }
<<<<<<< HEAD

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
                        SearchDestinationView(searchText: searchItem)
                    }, label: {
                        Text(searchItem)
                        .font(Font.body)
                        .padding(.horizontal, 16)
                    })
                }
            }
=======
    
    func DestinationView() -> some View {
        Text("Search Text: \(searchText)")
    }

    // *** displaying search-related stuff below***
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
>>>>>>> fc0d644 (rebase)
        }
    }
    
    func showSuggestions() -> some View {
<<<<<<< HEAD
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
                        SearchDestinationView(searchText: suggestion.name)
                    }, label: {
                        Text(suggestion.name)
                            .font(Font.body)
                            .padding(.horizontal, 16)
                            .frame(alignment: .leading)
                    })
                }
            }
=======
        VStack(alignment: .leading, spacing: 8) {
            Text("Suggestions")
                .font(Font.caption)
                .foregroundColor(.gray)
                .padding(.leading, 16)
                .frame(alignment: .leading)
            
            Divider()

            ForEach(self.getSuggestions(for: searchText), id: \.id) { suggestion in
                NavigationLink(destination: {
                    //
                }, label: {
                    Text(suggestion.name)
                        .font(Font.body)
                        .padding(.horizontal, 16)
                        .frame(alignment: .leading)
                })
            }

            Spacer()
>>>>>>> fc0d644 (rebase)
        }
    }
}
