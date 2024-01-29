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
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Button {
            // TODO: Update sequence on click
            // tabSelection = .Topics
        } label: {
            Text(topic.displaySubtopicName ?? topic.displayTopicName ?? topic.topicName)
                .font(Font.button)
                .clipShape(RoundedRectangle(cornerRadius: 2))
        }
        .purpleTopicCard(width: width, height: height)
    }
}
