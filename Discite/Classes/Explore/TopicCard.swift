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
            // TODO: Update sequence on click
            
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
        .cardWithShadow(width: 140, height: 150)
    }
}
