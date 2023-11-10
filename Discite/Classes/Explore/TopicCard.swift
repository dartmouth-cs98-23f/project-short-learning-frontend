//
//  TopicCard.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import SwiftUI

struct TopicCard: View {
    
    @EnvironmentObject var sequence: Sequence
    var topic: Topic
    
    var body: some View {
        NavigationLink {
            // Navigate to Watch on click, placeholder for now
            WatchView()
            
        } label: {
            Button {
                // Update sequence on click
                
            } label: {
                VStack(spacing: 12) {
                    Image(systemName: topic.thumbnailURL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text(topic.topicName)
                        .font(Font.button)
                }
            }
            .cardButtonFrame(width: 140, height: 150)
        }

    }
}

#Preview {
    let topic = ExploreService.fetchTestTopic()
    
    if topic != nil {
        return TopicCard(topic: topic!)
    } else {
        return Text("Failed to fetch topic.")
    }
    
}
