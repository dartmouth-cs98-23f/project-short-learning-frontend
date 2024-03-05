//
//  MainExplorePage.swift
//  Discite
//
//  Created by Jessie Li on 3/3/24.
//

import SwiftUI

struct MainExplorePage: View {
    @StateObject var viewModel = MainExploreViewModel()
    @Binding var searchText: String

    @Environment(\.isSearching)
    private var isSearching: Bool
    
    var body: some View {
//         NavigationStack {
            VStack(alignment: .leading) {
                // page title
//                Text("Explore.Title")
//                    .font(Font.H2)
//                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // search bar here
                // SearchBar(viewModel: searchViewModel)
                
                ScrollView(.vertical) {
                    LazyVStack(spacing: 18) {
                        
                        ForEach(viewModel.topicsAndRolesVideos, id: \.id) { video in
                            
                            // topic carousel for topics
                            if let topicVideo = video as? TopicVideo {
                                topicCarousel(topicVideo: topicVideo)
                            
                            // vertical role carousel for roles
                            } else if let roleVideo = video as? RoleVideo {
                                rolesCarousel(roleVideo: roleVideo)
                            } else {
                                
                            }
                        }
                        
                        Spacer()
                        
                        // loading indicator at the bottom
                        ProgressView()
                            .padding(.vertical, 18)
                            .frame(maxWidth: .infinity)
                            .onAppear {
                                viewModel.loadNextExplorePage()
                            }
                        
                    }
                }
            }
            .overlay {
                if isSearching && !searchText.isEmpty {
                    SearchSuggestionsList(searchText: $searchText)
                }
            }
            .padding(.horizontal, 18)
            
            NavigationBar()
            
        // }
    }
    
    @ViewBuilder
    private func rolesCarousel(roleVideo: RoleVideo) -> some View {
        VStack(alignment: .leading) {
            // title
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text("ROLE")
                        .foregroundColor(.secondaryPink)
                    Text(roleVideo.title)
                        .font(.H4)
                }
                Spacer()
                NavigationLink {
                    
                } label: {
                    Text("See more")
                        .font(.small)
                        .foregroundStyle(Color.secondaryPink)
                }
            }
            
            // playlists
            VStack(alignment: .leading, spacing: 12) {
                ForEach(roleVideo.videos) { playlist in
                    singlePlaylist(playlist: playlist)
                    Divider()
                }
            }
        }
        .padding(.bottom, 12)
    }
    
    @ViewBuilder
    private func topicCarousel(topicVideo: TopicVideo) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // title
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("TOPIC")
                        .foregroundColor(.primaryPurpleLight)
                    
                    Text(topicVideo.title)
                        .lineLimit(2)
                        .clipped()
                        .font(.H5)
                }
                
                Spacer(minLength: 24)
                NavigationLink {
                    
                } label: {
                    Text("See more")
                        .font(.small)
                        .foregroundStyle(Color.primaryPurple)
                }
            }
            
            // playlist previews
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(topicVideo.videos) { playlist in
                        ExplorePlaylistPreviewCard(playlist: playlist)
                            .padding(.bottom, 18)
                    }
                }
            }
        }
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
            Button {
                
            } label: {
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundStyle(Color.primaryPurpleLight)
            }
            
        }
    }
}

#Preview {
    MainExplorePageSearchWrapper()
        .environment(TabSelectionManager(selection: .Explore))
        .environmentObject(User())
}
