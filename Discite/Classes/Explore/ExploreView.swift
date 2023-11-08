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
        
        if recommender.recommendations != nil {
            topicScrollView(heading: "Explore.Topics.Title", topics: recommender.recommendations!.topics)
        } else {
            Text("No topics to show.")
        }
    }
    
    // Horizontally scrolling list of topics
    func topicScrollView(heading: String, topics: [Topic]) -> some View {
        VStack {
            Text(heading).font(Font.H5)

            ScrollView(.horizontal) {
                ForEach(topics) { topic in
                    TopicCard(topic: topic)
                }
            }
        }
    }
    
}

#Preview {
    ExploreView()
}
