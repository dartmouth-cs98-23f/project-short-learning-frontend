//
//  ExploreView.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import SwiftUI

struct ExploreView: View {
    
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
                
                // Section: Continue learning (current playlist)
                if let playlist = sequence.currentPlaylist() {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Continue learning").font(.H5)
                        ContinueCard(playlist: playlist)
                    }
                }
                
                // Section: My interests (topics)
                topicScrollSection(heading: "Recommended topics", topics: recommendations.topics)
                
                // Section: Continue learning (rest of playlists)
                if let topic = sequence.topic {
                    playlistScrollSection(heading: "More in \(topic)",
                                          playlists: sequence.playlists)
                }
                
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
        VStack(alignment: .leading, spacing: 12) {
            Text(heading).font(Font.H5)

            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(topics, id: \._id) { topic in
                        TopicCard(tabSelection: $tabSelection, topic: topic)
                    }
                }
            }
            
        }
    }
    
    func playlistScrollSection(heading: String, playlists: [Playlist]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(heading).font(Font.H5)

            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(Array(playlists.enumerated()), id: \.offset) { index, playlist in
                        PlaylistCard(tabSelection: $tabSelection, playlist: playlist, index: index, width: 200, height: 150)
                    }
                }
            }
        }
    }
    
}
