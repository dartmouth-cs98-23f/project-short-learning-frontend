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
    @Binding var tabSelection: Navigator.Tab
    @State var searchText: String = ""
    
    var body: some View {

        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                Text("Explore.Title")
                    .font(Font.H2)
                    .padding(.top, 18)
                
                SearchBar(placeholder: "Search for topics and playlists",
                          text: $searchText)
                .foregroundColor(.primaryBlueNavy)
                
                // Section: Recommended topics
                topicScrollSection(heading: "Recommended topics", topics: recommendations.topics)
                
                // Section: Recommended playlists
                playlistScrollSection(heading: "Recommended playlists", playlists: sequence.playlists)
                
                Spacer()
            }
            .padding(18)
        }
        .task {
            await recommendations.load()
        }

    }
    
    // Horizontally scrolling list of topics
    func topicScrollSection(heading: String, topics: [Topic]) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            
            HStack(alignment: .center) {
                Text(heading).font(Font.H5)
                Button {
                    tabSelection = .Topics
                } label: {
                    Text("See all topics")
                        .font(.system(size: 12))
                        .padding([.leading], 40)
                        .foregroundColor(Color.primaryPurpleDark)
                }
            }
            
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(topics, id: \._id) { topic in
                        TopicCard(tabSelection: $tabSelection, topic: topic, width: 100, height: 30)
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
