//
//  MainExplorePage.swift
//  Discite
//
//  Created by Jessie Li on 3/3/24.
//

import SwiftUI

struct MainExplorePage: View {
    @StateObject var viewModel = ExploreViewModel()
    @StateObject var searchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // page title
                Text("Explore.Title")
                    .font(Font.H2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // search bar here
                ScrollView(.vertical) {
                    VStack(spacing: 12) {
                        // topic recommendations carousel
                        topicScrollSection()
                            .border(.pink)
                        
                        ForEach(0..<5) { _ in
                            playlistCarousel()
                        }
                        
                        Spacer()
                        
                    }
                }
            }
            .padding(.horizontal, 18)
            
            NavigationBar()
        }
    }

    // horizontally scrolling list of topics
    @ViewBuilder
    private func topicScrollSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach($viewModel.topicRecommendations) { $topic in
                        TopicTagWithNavigation(topic: $topic)
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
    
    @ViewBuilder
    private func playlistCarousel() -> some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("Topic")
                    .font(.subtitle1)
                
                Spacer()
                
                NavigationLink {
                    
                } label: {
                    Text("Details")
                        .font(.small)
                }
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<5) { _ in
                        Rectangle()
                            .fill(Color.grayNeutral)
                            .frame(width: 200, height: 200)
                        // PlaylistPreviewCard(playlist: playlist)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.bottom, 12)
        // .border(.blue)
    }
}

#Preview {
    MainExplorePage()
        .environment(TabSelectionManager(selection: .Explore))
}
