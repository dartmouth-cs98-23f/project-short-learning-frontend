//
//  AllTopics.swift
//  Discite
//
//  Created by Bansharee Ireen on 1/29/24.
//  Updated by Jessie Li on 2/14/24.
//

import SwiftUI

struct AllTopics: View {
    private var columns: [GridItem] = [
            GridItem(.flexible()), GridItem(.flexible())
    ]
    
    @State var topics: [TopicTag] = []
    @State private var selectedSortOption: SortOption = .Recommendations
    
    enum SortOption: String, CaseIterable {
        case Recommendations
        case Name
    }

    private var sortedTopics: [TopicTag]? {
        switch selectedSortOption {
        case .Recommendations:  // Recommendations
            return topics
        case .Name:             // Name
            return topics.sorted { $0.topicName < $1.topicName }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Sort by:")
                        
                        Picker("", selection: $selectedSortOption) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text("\(option.rawValue)")
                                    .tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(0)
                    }
                    
                    topicScrollSection()
                        .animation(.easeIn(duration: 0.3), value: topics.isEmpty)
                    
                }
                .navigationTitle("Topics")
                .padding(18)
            }
            .task {
                if topics.isEmpty {
                    do { topics = try await ExploreService.mockGetAllTopics()
                    } catch {
                        print("Error fetching topics: \(error)")
                    }
    
                }

            }
        }
    }
    
    // Vertically scrolling 2 column grid of topics
    func topicScrollSection() -> some View {
        LazyVGrid(columns: columns, spacing: 18) {
            ForEach(sortedTopics ?? []) { topic in
                LargeTopicTagWithNavigation(topic: .constant(topic), maxHeight: 100)
            }
        }
    }
}
