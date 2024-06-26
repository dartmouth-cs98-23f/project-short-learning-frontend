//
//  SearchDestinationPage.swift
//  Discite
//
//  Created by Bansharee Ireen & Jessie Li on 3/4/24.
//

import SwiftUI

struct SearchDestinationPage: View {
    @ObservedObject var viewModel = ExploreSearchViewModel.shared
    
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading) {
                Text("Results for")
                    .font(.subtitle1)
                
                Text(text)
                    .font(.H4)
                    .foregroundStyle(Color.primaryPurpleLight)
            }
            
            if case .loading = viewModel.state {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                let tabItems: [CustomTabItem] = [
                    CustomTabItem("Playlists") {
                        playlistResults(viewModel.resultPlaylists ?? [])
                    },
                    CustomTabItem("Topics") {
                        topicResults(viewModel.resultTopics ?? [])
                    },
                    CustomTabItem("Accounts") {
                        userResults(viewModel.resultUsers ?? [])
                    }
                ]

                CustomTabView(tabItems)

            }
        
        }
        .onAppear {
            ExploreSearchViewModel.shared.getSearchResults(query: text)
        }
        .padding(.horizontal, 18)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func playlistResults(_ playlists: [PlaylistPreview]) -> some View {
        if playlists.isEmpty {
            Text("No playlists match the query '\(text).'")
            
        } else {
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    ForEach(playlists) { playlist in
                        singlePlaylist(playlist: playlist)
                    }
                }
            }
        
        }
    }
    
    @ViewBuilder
    func topicResults(_ topics: [TopicSearchResult]) -> some View {
        let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
        
        if topics.isEmpty {
            Text("No topics match the query '\(text).'")
            
        } else {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(topics) { topic in
                        NavigationLink {
                            TopicPageView(topicSeed: TopicTag(
                                id: topic.id,
                                topicId: topic.topicId,
                                topicName: topic.topic))
                            
                        } label: {
                            VStack(alignment: .leading) {
                                HStack(spacing: 4) {
                                    Image(systemName: "tag")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 16, height: 16)
                                    
                                    Text("TOPIC")
                                        .font(Font.body1)
                                }
                                
                                Text(topic.topic)
                                    .font(.subtitle2)
                                    .lineLimit(3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 18)
                            .frame(maxWidth: .infinity, maxHeight: 250)
                            .foregroundColor(.primaryBlueBlack)
                            .background {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.primaryPurpleLightest)
                                    .strokeBorder(Color.primaryPurpleLight, lineWidth: 2)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func userResults(_ users: [UserSearchResult]) -> some View {
        if users.isEmpty {
            Text("No accounts match the query '\(text).'")
            
        } else {
            ScrollView(.vertical) {
                ForEach(users) { user in
                    NavigationLink {
                        
                    } label: {
                        singleUser(user: user)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func singleUser(user: UserSearchResult) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
            
            VStack {
                Text(user.firstName + " " + user.lastName).font(.body1)
                Text(user.username).font(.button)
            }
        }
        .padding(.vertical, 6)
    }
    
    @ViewBuilder
    func singlePlaylist(playlist: PlaylistPreview) -> some View {
        HStack(spacing: 8) {
            // image
            if let imageStringURL = playlist.thumbnailURL,
               let imageURL = URL(string: imageStringURL) {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipped()
                    
                } placeholder: {
                    Rectangle()
                        .foregroundStyle(Color.grayDark)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 60)
                }
            } else {
                Rectangle()
                    .foregroundStyle(Color.grayDark)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
            }
            
            // title
            VStack(alignment: .leading) {
                Text(playlist.title)
                    .font(.subtitle2)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(playlist.description ?? "")
                    .font(.body2)
                    .lineLimit(2)
                    .foregroundStyle(Color.grayDark)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .clipped()
            }
            
            // open Watch
            NavigationLink {
                WatchFullScreenCover(seed: playlist.playlistId)
                
            } label: {
                Image(systemName: "play.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundStyle(Color.primaryBlueBlack)
            }
            .padding(4)
            
        }
    }
}

#Preview {
    SearchDestinationPage(text: "jessie")
}
