//
//  MainExplorePage.swift
//  Discite
//
//  Created by Jessie Li on 3/3/24.
//

import SwiftUI

struct MainExplorePage: View {
    @Environment(TabSelectionManager.self) private var tabSelection
    @StateObject var viewModel = MainExploreViewModel()
    @Binding var searchText: String
    @State var isWatchShowing: Bool = false

    @Environment(\.isSearching)
    private var isSearching: Bool
    
    var body: some View {
            VStack(alignment: .leading) {
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
            .fullScreenCover(isPresented: $isWatchShowing) {
                VStack(alignment: .leading) {
                    Button {
                        isWatchShowing = false
                        
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.secondaryPeachLight)
                            .frame(width: 22, height: 22)
                    }
                    .frame(maxHeight: 24, alignment: .leading)
                    .padding(.horizontal, 18)
                    
                    GeometryReader { geo in
                        WatchPage(size: geo.size,
                                  safeArea: geo.safeAreaInsets,
                                  seed: tabSelection.playlistSeed,
                                  includeNavigation: false)
                    }
                    .containerRelativeFrame([.vertical])
                }
                .background(.black)
            }
            .overlay {
                if isSearching && !searchText.isEmpty {
                    SearchSuggestionsList(searchText: $searchText)
                }
            }
            .padding(.horizontal, 18)
            
            NavigationBar()
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
                    TopicPageView(topicSeed: TopicTag(
                        id: topicVideo.id,
                        topicId: topicVideo.topicId,
                        topicName: topicVideo.title
                    ))
                    
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
                        ExplorePlaylistPreviewCard(
                            playlist: playlist,
                            isWatchShowing: $isWatchShowing)
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
