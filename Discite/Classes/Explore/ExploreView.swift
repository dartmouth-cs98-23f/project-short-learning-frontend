//
//  ExploreView.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import SwiftUI

struct ExploreView: View {

    @EnvironmentObject var sequence: Sequence
    @ObservedObject var recommender = Recommender()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 24) {
            
            Text("Explore.Title")
                .font(Font.H2)
                .padding(.top, 18)
            
            // Section: My interests (topics)
            if recommender.recommendations != nil {
                topicScrollSection(heading: "My interests", topics: recommender.recommendations!.topics)
            } else {
                Text("No topics to show.")
            }
            
            // Section: Continue learning (playlists)
            
            Spacer()
        }
        .padding(32)
    }
    
    // Horizontally scrolling list of topics
    func topicScrollSection(heading: String, topics: [Topic]) -> some View {
        VStack(alignment: .leading) {
            Text(heading).font(Font.H4)

            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(topics) { topic in
                        TopicCard(topic: topic)
                    }
                }
            }
        }
    }
    
}

#Preview {
    ExploreView()
}
