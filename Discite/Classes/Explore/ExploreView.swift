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
    
    var body: some View {
        NavigationStack {
            LazyVStack(alignment: .leading) {
                Text("Explore.Title")
                .font(Font.H2)
                .padding(.top, 18)
                .padding([.leading, .trailing], 12)

                HStack {
                    SearchBar(placeholder: "Search", viewModel: searchViewModel)
                    .padding(.bottom, 10)
                    .foregroundColor(.primaryBlueNavy)
                }
            }
            .background(
                NavigationLink(
                    destination: SearchDestinationView(viewModel: searchViewModel),
                    isActive: $searchViewModel.shouldNavigate,
                    label: EmptyView.init
                )
                .opacity(0)
            )
               
            // no focus + no text, display regular page
            if !searchViewModel.isFocused && searchViewModel.searchText.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Section: Recommended topics
                        topicScrollSection(heading: "Recommended topics", topics: recommendations.topics)
        
                        // Section: Recommended playlists
                        playlistScrollSection(heading: "Recommended playlists", playlists: sequence.playlists)
                    }
                }
                .task {
                    await recommendations.load()
                }
            }

            Spacer()
        }
        .padding(18)
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
