//
//  ExploreView.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//  Updated by Bansharee Ireen.
//  Updated by Jessie Li on 2/14/24.
//

import SwiftUI

struct ExploreView: View {
    @Binding var history: [String]
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var viewModel: ExploreViewModel
    @StateObject var searchViewModel: SearchViewModel
    let saveAction: () -> Void

    init(history: Binding<[String]>, saveAction: @escaping () -> Void) {
        _history = history
        _viewModel = StateObject(wrappedValue: ExploreViewModel())
        _searchViewModel = StateObject(wrappedValue: SearchViewModel(history: history))
        self.saveAction = saveAction
    }
    
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 2), GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Explore.Title")
                .font(Font.H2)
                .padding(.top, 18)
                .padding([.leading, .trailing], 12)

                HStack {
                    SearchBar(placeholder: "Search", viewModel: searchViewModel)
                    .padding(.bottom, 10)
                    .foregroundColor(.primaryBlueNavy)
                }
            }
            .background {
                NavigationLink(value: "Search", label: {
                    EmptyView()
                })
                .animation(.smooth(duration: 0.3), value: searchViewModel.shouldNavigate)
                .navigationDestination(isPresented: $searchViewModel.shouldNavigate, destination: {
                    SearchDestinationView(history: $history, searchText: searchViewModel.searchText, searchables: searchViewModel.searchables)
                })
            }
            .padding(.horizontal, 18)
            
            // no focus + no text, display regular page
            if !searchViewModel.isFocused && searchViewModel.searchText.isEmpty {
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Section: Recommended topics
                        if !viewModel.topicRecommendations.isEmpty {
                            topicScrollSection(topics: $viewModel.topicRecommendations)
                            
                        } else if viewModel.error != nil {
                            Text("Error fetching topic recommendations.")
                                .frame(minHeight: 40)
                            
                        } else {
                            placeholderRectangle(minHeight: 40)
                                .task {
                                    await viewModel.getTopicRecommendations()
                                }
                        }
                        
                        // Section: Recommended playlists
                        if let playlistRecs = viewModel.playlistRecommendations {
                            playlistScrollSection(playlists: playlistRecs)
                            
                        } else {
                            placeholderGrid()
                                .task {
                                    await viewModel.getPlaylistRecommendations()
                                }
                        }
                        
                    }
                }
                .animation(.easeIn(duration: 0.3),
                           value: viewModel.topicRecommendations.isEmpty)
                .animation(.easeIn(duration: 0.3),
                           value: viewModel.playlistRecommendations == nil)
            }
            
            Spacer()
            
            NavigationBar()
        }
        .ignoresSafeArea(edges: [.bottom, .leading, .trailing])
        .onAppear {
            Task {
                await viewModel.getTopicRecommendations()
                await viewModel.getPlaylistRecommendations()
                searchViewModel.searchables = viewModel.createSearchables()
                searchViewModel.loadHistory(historyFromStore: history)
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
    
    // Horizontally scrolling list of topics
    @ViewBuilder
    func topicScrollSection(topics: Binding<[TopicTag]>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Topic tags
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(topics) { topic in
                        TopicTagWithNavigation(topic: topic)
                    }
                    
                    NavigationLink(destination: {
                        AllTopics()
                    }, label: {
                        Text("See all")
                            .font(.small)
                            .foregroundColor(.primaryPurple)
                    })
                }
            }
            .frame(minHeight: 40)
        }
        .padding(.horizontal, 18)
    }
    
    // Vertically scrolling 2 column grid of playlists
    @ViewBuilder
    func playlistScrollSection(playlists: [PlaylistPreview]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(playlists) { playlist in
                    PlaylistPreviewCard(playlist: playlist)
                }
            }
        }
    }
    
    @ViewBuilder
    func placeholderRectangle(minHeight: CGFloat) -> some View {
        Rectangle()
            .frame(maxWidth: .infinity, minHeight: minHeight)
            .foregroundColor(.grayLight)
    }
    
    @ViewBuilder
    func placeholderGrid() -> some View {
        LazyVGrid(columns: columns, spacing: 1) {
            ForEach(0..<10, id: \.self) { _ in
                placeholderRectangle(minHeight: 10)
                    .aspectRatio(1.0, contentMode: .fit)
                    
            }
        }
    }
    
}
