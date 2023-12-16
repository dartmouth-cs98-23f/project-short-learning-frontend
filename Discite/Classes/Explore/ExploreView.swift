//
//  ExploreView.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import SwiftUI

struct ExploreView: View {

    @EnvironmentObject var context: MyContext
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
                if !context.playlists.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Continue learning").font(.H5)
                        ContinueCard(playlist: context.playlists[context.currentIndex])
                    }
                }
                
                // Section: My interests (topics)
                topicScrollSection(heading: "Recommended topics", topics: context.topics)
                
                // Section: Continue learning (rest of playlists)
                if context.playlists.count > 0 {
                    playlistScrollSection(heading: "More in \(context.playlists[0].topic)",
                                          playlists: context.playlists)
                }
                
                Spacer()
            }
            .padding(18)
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
