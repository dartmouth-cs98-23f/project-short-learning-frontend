//
//  TopicCard.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import SwiftUI

struct LargeTopicTagWithNavigation: View {
    @Binding var topic: TopicTag
    var maxHeight: CGFloat

    var body: some View {

        NavigationLink(destination: {
            TopicPageView(topicSeed: topic)

        }, label: {
            VStack(alignment: .leading) {
                HStack(spacing: 4) {
                    Image(systemName: "tag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)

                    Text("TOPIC")
                        .font(Font.body1)
                }

                Text(topic.topicName)
                    .font(Font.H6)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

            }
            .padding(.horizontal, 12)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity, maxHeight: maxHeight)
            .foregroundColor(.primaryBlueBlack)
            .background {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.primaryPurpleLightest)
                    .strokeBorder(Color.primaryPurpleLight, lineWidth: 2)
            }
        })
    }
}

struct TopicTagWithNavigation: View {
    @Binding var topic: TopicTag

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

#Preview {
    VStack(alignment: .leading) {
        HStack(spacing: 4) {
            Image(systemName: "tag")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)

            Text("TOPIC")
                .font(Font.body1)
        }
        .border(.pink)

        Text("Topic")
            .font(Font.H6)
            .lineLimit(2)
            .border(.blue)
            .frame(maxWidth: .infinity, alignment: .leading)

    }
    .padding(.horizontal, 12)
    .padding(.vertical, 18)
    .frame(maxWidth: .infinity, maxHeight: 100)
    .foregroundColor(.primaryBlueBlack)
    .background {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.primaryPurpleLightest)
            .strokeBorder(Color.primaryPurpleLight, lineWidth: 2)
    }
}
