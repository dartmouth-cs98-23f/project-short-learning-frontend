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
    @Binding var tabSelection: Navigator.Tab
    @StateObject var recommendations = Recommendations()
    
    @State private var selectedSortOption = 0
    let sortOptions = ["Relevance", "Recommendations", "Name"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Sort by:") // Label for the Picker
                        .padding(0)
                        
                        Picker("", selection: $selectedSortOption) {
                            ForEach(0..<sortOptions.count) { index in
                                Text(self.sortOptions[index]).tag(index)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(0)

                        Spacer()
                        Text("Filters")
                    }
                    topicScrollSection(topics: recommendations.topics)
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
                    TopicPageView(sequence: sequence, tabSelection: $tabSelection, topic: topic)
                }, label: {
                    TopicCard(tabSelection: $tabSelection, topic: topic, width: 170, height: 100)
                })
            }
        }
    }
}
