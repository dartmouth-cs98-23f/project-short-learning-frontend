//
//  ExploreView.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import SwiftUI

struct ExploreView: View {

    @EnvironmentObject var sequence: Sequence
    @EnvironmentObject var recommendations: Recommendations
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
                if sequence.length() != 0 {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Continue learning").font(.H5)
                        ContinueCard(playlist: sequence.currentPlaylist()!)
                    }
                }
                
                // Section: My interests (topics)
                if recommendations.fetchSuccessful {
                    topicScrollSection(heading: "Recommended topics", topics: recommendations.getTopics()!)
                }
                
                // Section: Continue learning (rest of playlists)
                if sequence.playlists.count > 0 {
                    playlistScrollSection(heading: sequence.topic != nil ? "More in \(sequence.topic!)" : "More like this", playlists: sequence.allPlaylists())
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

#Preview {
    
    let sequence = VideoService.fetchTestSequence()
    let recommendations = ExploreService.fetchTestRecommendations()
    
    if sequence == nil || recommendations == nil {
        return Text("No sequence or recommendations.")
    }
    
    return ExploreView(tabSelection: .constant(Navigator.Tab.Explore))
        .environmentObject(recommendations!)
        .environmentObject(sequence!)
}
