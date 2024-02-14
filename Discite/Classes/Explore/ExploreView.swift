//
//  ExploreView.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

// Explore View --> Click Topic Tag --> Topic Tag is a nav link, brings you to TopicPageView seeded by topicTag
import SwiftUI

struct ExploreView: View {

    @StateObject var searchViewModel = SearchViewModel()
    @StateObject var viewModel = ExploreViewModel()
    
    private var columns: [GridItem] = [
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
            .background(
                NavigationLink(
                    destination: SearchDestinationView(searchText: searchViewModel.searchText),
                    isActive: $searchViewModel.shouldNavigate,
                    label: EmptyView.init
                )
                .opacity(0)
            )
            .padding(.horizontal, 18)
            
            // no focus + no text, display regular page
            if !searchViewModel.isFocused && searchViewModel.searchText.isEmpty {
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Section: Recommended topics
                        topicRecommendationsHeader()
                            .padding(.horizontal, 18)
                        
                        if let topicRecs = viewModel.topicRecommendations {
                            topicScrollSection(topics: topicRecs)
                            
                        } else {
                            placeholderRectangle(minHeight: 40)
                                .task {
                                    await viewModel.getTopicRecommendations()
                                }
                        }
                        
                        // Section: Recommended playlists
                        Text("Recommended playlists")
                            .font(Font.H5)
                            .padding(.horizontal, 18)
                        
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
                .animation(.easeIn(duration: 0.5), value: viewModel.topicRecommendations == nil)
                .animation(.easeIn(duration: 0.5), value: viewModel.playlistRecommendations == nil)
            }
            
            Spacer()
            
            NavigationBar()
        }
        .ignoresSafeArea(edges: [.bottom, .leading, .trailing])
    }
    
    // Horizontally scrolling list of topics
    @ViewBuilder
    func topicScrollSection(topics: [TopicTag]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Topic tags
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(topics) { topic in
                        TopicTagWithNavigation(topic: topic)
                    }
                }
            }
            .frame(minHeight: 40)
        }
        .padding(.horizontal, 18)
    }
    
    @ViewBuilder
    func topicRecommendationsHeader() -> some View {
        HStack(alignment: .center) {
            Text("Recommended topics").font(Font.H5)
            
            Spacer()
            
            NavigationLink(destination: {
                // AllTopics(sequence: sequence)
            }, label: {
                Text("See all topics")
                    .font(.small)
                    .foregroundColor(.primaryPurple)
            })
        }
    }
    
    // Vertically scrolling 2 column grid of playlists
    @ViewBuilder
    func playlistScrollSection(playlists: [PlaylistPreview]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(Array(playlists.enumerated()), id: \.offset) { index, playlist in
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

#Preview {
    ExploreView()
        .environment(TabSelectionManager(selection: .Explore))
}
