//
//  ExploreView.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import SwiftUI

struct ExploreView: View {
    @State private var columns: [GridItem] = [
            GridItem(.flexible()), GridItem(.flexible())
    ]
    @ObservedObject var sequence: Sequence
    @StateObject var recommendations = Recommendations()
    @StateObject var searchViewModel = SearchViewModel()
    @Binding var tabSelection: Navigator.Tab
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            HStack {
                SearchBar(placeholder: "Search", viewModel: searchViewModel)
                .padding()
                .foregroundColor(.primaryBlueNavy)

                if !searchViewModel.searchText.isEmpty {
                    CancelButton(viewModel: searchViewModel, cancelButtonOffset: 100)
                }
            }
            .navigationTitle("Explore.Title")
               

            /////// on focus, no inpiut -> search history
            // if isEditing && searchViewModel.searchText.isEmpty {
            //     // search history section
            //     VStack(alignment: .leading, spacing: 8) {
            //         Text("Recent Searches")
            //             .font(Font.caption)
            //             .foregroundColor(.gray)
            //             .padding(.leading, 16)
                    
            //         ForEach(searchViewModel.searchHistory, id: \.self) { searchItem in
            //             Text(searchItem)
            //                 .font(Font.body)
            //                 .padding(.horizontal, 16)
            //         }
            //     }
            // } else 
            if searchViewModel.searchText.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Section: Recommended topics
                        topicScrollSection(heading: "Recommended topics", topics: recommendations.topics)
        
                        // Section: Recommended playlists
                        playlistScrollSection(heading: "Recommended playlists", playlists: sequence.playlists)
                    }
                    .padding(18)
                }
                .task {
                    await recommendations.load()
                }
            } else if !searchViewModel.searchText.isEmpty {
                // Display search suggestions
                VStack(alignment: .leading, spacing: 8) {
                    Text("Search Suggestions")
                        .font(Font.caption)
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                        .frame(alignment: .leading)
                    
                    ForEach(searchViewModel.getSuggestions(for: searchViewModel.searchText), id: \.self) { suggestion in
                        Text(suggestion)
                            .font(Font.body)
                            .padding(.horizontal, 16)
                            .frame(alignment: .leading)
                    }

                    Spacer()
                }
            }
        }
    }
 
    // Horizontally scrolling list of topics
    func topicScrollSection(heading: String, topics: [Topic]) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            
            HStack(alignment: .center) {
                Text(heading).font(Font.H5)
                
                Spacer()
                
                NavigationLink(destination: {
                    AllTopics(sequence: sequence, tabSelection: $tabSelection)
                }, label: {
                    Text("See all topics")
                    .font(.system(size: 12))
                    .foregroundColor(Color.primaryPurpleDark)
                })
            }
            
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(topics, id: \._id) { topic in
                        NavigationLink(destination: {
                            TopicPageView(sequence: sequence, tabSelection: $tabSelection, topic: topic)
                        }, label: {
                            TopicCard(tabSelection: $tabSelection, topic: topic, width: 100, height: 30)
                        })
                    }
                }
            }
            .padding([.top], 5)
        }
    }
    
    // Vertically scrolling 2 column grid of playlists
    func playlistScrollSection(heading: String, playlists: [Playlist]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(heading).font(Font.H5)
            
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(Array(playlists.enumerated()), id: \.offset) { index, playlist in
                    PlaylistCard(tabSelection: $tabSelection, playlist: playlist, index: index, width: 165, height: 200)
                }
            }
        }
    }
}
