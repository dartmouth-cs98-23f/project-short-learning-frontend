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
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Text(topic.topicName)
            .font(Font.button)
            .clipShape(RoundedRectangle(cornerRadius: 2))
            .purpleTopicCard(width: width, height: height)
    }
}

struct TopicTagWithNavigation: View {
    var topic: TopicTag
    
    var body: some View {
        
        NavigationLink(destination: {
            TopicPageView(topicSeed: topic)
            
        }, label: {
            HStack(spacing: 4) {
                Image(systemName: "tag")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                
                Text(topic.topicName)
                    .font(Font.button)
            }
            .padding(8)
            .foregroundColor(.primaryBlueBlack)
            .background {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.primaryPurpleLightest)
                    .strokeBorder(Color.primaryPurpleLight, lineWidth: 2)
            }

        })
    }
}
