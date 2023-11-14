//
//  TopicCard.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import SwiftUI

struct TopicCard: View {
    
    @EnvironmentObject var sequence: Sequence
    @Binding var tabSelection: Navigator.Tab
    
    var topic: Topic
    
    var body: some View {
        Button {
            // Update sequence on click
            sequence.replaceQueueWithTopic(topicId: topic._id, numPlaylists: 2)
            tabSelection = .Watch
            
        } label: {
            VStack(spacing: 12) {
                Image(systemName: topic.thumbnailURL)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                Text(topic.displaySubtopicName ?? topic.displayTopicName ?? topic.topicName)
                    .font(Font.button)
            }
        }
        .cardButtonFrame(width: 140, height: 150)
    }
}

#Preview {
    let topic = ExploreService.fetchTestTopic()
    
    if topic != nil {
        return TopicCard(tabSelection: .constant(Navigator.Tab.Explore), topic: topic!)
    } else {
        return Text("Failed to fetch topic.")
    }
    
}
