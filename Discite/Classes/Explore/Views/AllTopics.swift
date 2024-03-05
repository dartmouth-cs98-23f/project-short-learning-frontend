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
    @State var searchText: String = ""
    
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
    
    private var filteredAndSortedTopics: [TopicTag] {
        var filteredTopics = topics
        // filter topics
        if !searchText.isEmpty {
            filteredTopics = filteredTopics.filter { $0.topicName.localizedCaseInsensitiveContains(searchText) }
        }
        // sort topics
        switch selectedSortOption {
        case .Recommendations:
            return filteredTopics
        case .Name:
            return filteredTopics.sorted { $0.topicName < $1.topicName }
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
                    
                    topicScrollSection(searchText: searchText)
                        .animation(.easeIn(duration: 0.3), value: topics.isEmpty)
                    
                }
                .navigationTitle("All Topics")
                .padding(18)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .task {
                if topics.isEmpty {
                    do { topics = try await ExploreService.getAllTopics()
                    } catch {
                        print("Error fetching topics: \(error)")
                    }
                }
            }
        }
    }
    
    // Vertically scrolling 2 column grid of topics
    func topicScrollSection(searchText: String) -> some View {
        LazyVGrid(columns: columns, spacing: 18) {
            ForEach(filteredAndSortedTopics) { topic in
                LargeTopicTagWithNavigation(topic: .constant(topic), maxHeight: 100)
            }
        }
    }
}
