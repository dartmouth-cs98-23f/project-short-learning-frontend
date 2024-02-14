//
//  AllTopics.swift
//  Discite
//
//  Created by Bansharee Ireen on 1/29/24.
//

import SwiftUI

struct AllTopics: View {
    @State private var columns: [GridItem] = [
            GridItem(.flexible()), GridItem(.flexible())
    ]
    @ObservedObject var sequence: Sequence
    @StateObject var recommendations = Recommendations()
    
    @State private var selectedSortOption = 0
    let sortOptions = ["Relevance", "Recommendations", "Name"]

    private var sortedTopics: [Topic] {
        switch selectedSortOption {
        case 0: // Relevance
            return recommendations.topics
        case 1: // Recommendations
            return recommendations.topics
        case 2: // Name
            return recommendations.topics.sorted { $0.topicName < $1.topicName }
        default:
            return recommendations.topics
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Sort by:")
                        
                        Picker("", selection: $selectedSortOption) {
                            ForEach(0..<sortOptions.count) { index in
                                Text(self.sortOptions[index]).tag(index)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(0)
                    }
                    topicScrollSection(topics: sortedTopics)
                }
                .navigationTitle("Topics")
                .padding(18)
            }
            .task {
                await recommendations.load()
            }
        }
    }
    
    // Vertically scrolling 2 column grid of topics
    func topicScrollSection(topics: [Topic]) -> some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(topics, id: \._id) { topic in
                NavigationLink(destination: {
                    TopicPageView(sequence: sequence, topic: topic)
                }, label: {
                    TopicCard(topic: topic, width: 170, height: 100)
                })
            }
        }
    }
}
