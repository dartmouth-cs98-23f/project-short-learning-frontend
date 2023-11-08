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
                VStack(spacing: 12) {
                    Image(systemName: "moon.stars.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text(topic.title)
                        .font(Font.button)
                }
            }
            .frame(width: 140, height: 150)
            .background(Color.secondaryLightestBlue)
            .foregroundColor(Color.primaryBlueBlack)
            .cornerRadius(10)
            .shadow(color: Color.lightGray, radius: 2, x: 1, y: 4)
            .padding(12)
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
