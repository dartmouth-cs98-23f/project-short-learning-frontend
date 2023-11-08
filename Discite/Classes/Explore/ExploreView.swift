//
//  ExploreView.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import SwiftUI

struct ExploreView: View {

    @EnvironmentObject var sequence: Sequence
    @ObservedObject var explore: Explore = Explore()
    
    var body: some View {
        
        if explore.recommendations != nil {
            topicScrollView(heading: "Explore.Topics.Title", topics: explore.recommendations!.topics)
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
