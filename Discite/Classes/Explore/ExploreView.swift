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
    
    var body: some View {
        
        if recommendations.fetchSuccessful && sequence.playlists.count > 0 {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    
                    Text("Explore.Title")
                        .font(Font.H2)
                        .padding(.top, 18)
                    
                    // Section: My interests (topics)
                    topicScrollSection(heading: "My interests", topics: recommendations.getTopics()!)
                    
                    // Section: Continue learning (playlists)
                    playlistScrollSection(heading: "Continue learning", playlists: sequence.allPlaylists())
                    
                    Spacer()
                }
                .padding(32)
            }
            
        } else {
            Text("Something went wrong.")
        }

    }
    
    // Horizontally scrolling list of topics
    func topicScrollSection(heading: String, topics: [Topic]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(heading).font(Font.H4)

            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(topics, id: \._id) { topic in
                        TopicCard(tabSelection: $tabSelection, topic: topic)
                    }
                }
                .padding([.bottom, .top], 18)
            }
            
        }
    }
    
    func playlistScrollSection(heading: String, playlists: [Playlist]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(heading).font(Font.H4)

            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(Array(playlists.enumerated()), id: \.offset) { index, playlist in
                        PlaylistCard(tabSelection: $tabSelection, playlist: playlist, index: index)
                    }
                }
                .padding([.bottom, .top], 18)
            }
            
        }
    }
    
}

#Preview {
    
    let sequence = Sequence()
    let recommendations = Recommendations()
 
    return ExploreView(tabSelection: .constant(Navigator.Tab.Explore))
        .environmentObject(recommendations)
        .environmentObject(sequence)
}
