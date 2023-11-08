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
            WatchView(showSidebar: .constant(false))
            
        } label: {
            Button {
                // Update sequence on click
                
            } label: {
                VStack {
                    Image(systemName: "moon.stars.fill")
                    Text(topic.title)
                }
            }
            .frame(width: 100, height: 140)
            .background(Color.secondaryLightPeach)

        }

    }
}

#Preview {
    var previewTopic: Topic?
    
    ExploreService.fetchTestTopic { topic in
        previewTopic = topic
    } failure: { error in
        print("\(error)")
    }

    if previewTopic != nil {
        return TopicCard(topic: previewTopic!)
        
    } else {
        return Text("Failed to fetch topic.")
    }
    
}
