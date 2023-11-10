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

    var body: some View {
        
        VStack(alignment: .leading, spacing: 18) {
            
            Text("Explore.Title")
                .font(Font.H2)
                .padding(.top, 18)
            
            // Section: My interests (topics)
            topicScrollSection(heading: "My interests", topics: recommendations.getTopics())
            
            // Section: Continue learning (playlists)
            playlistScrollSection(heading: "Continue learning", playlists: sequence.allPlaylists())
            
            Spacer()
        }
        .padding(32)
    }
    
    // Horizontally scrolling list of topics
    func topicScrollSection(heading: String, topics: [Topic]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(heading).font(Font.H4)

            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(topics, id: \._id) { topic in
                        TopicCard(topic: topic)
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
                    ForEach(playlists) { playlist in
                        PlaylistCard(playlist: playlist)
                    }
                }
                .padding([.bottom, .top], 18)
            }
            
        }
    }
    
}

#Preview {
    
    let recommendations = ExploreService.fetchTestRecommendations()
    let sequence = VideoService.fetchTestSequence()
    
    if recommendations != nil && sequence != nil {
        return ExploreView()
            .environmentObject(recommendations!)
            .environmentObject(sequence!)
    } else {
        return Text("No topics to show.")
    }
}
