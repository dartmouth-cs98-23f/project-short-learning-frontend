//
//  MainExplorePage.swift
//  Discite
//
//  Created by Jessie Li on 3/3/24.
//

import SwiftUI

struct MainExplorePage: View {
    @StateObject var viewModel = MainExploreViewModel()
    
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
                        
                        // topic carousel
                        Group {
                            ForEach(viewModel.topicVideos) { topicVideo in
                                topicCarousel(topicVideo: topicVideo)
                            }
                        }
                        .border(.blue)
                        .frame(minHeight: 100)
                        .background(viewModel.topicVideos.isEmpty
                                    ? Color.grayLight
                                    : Color.clear)
                        
                        // roles list
                        Group {
                            ForEach(viewModel.roleVideos) { roleVideo in
                                rolesCarousel(roleVideo: roleVideo)
                            }
                        }
                        .border(.blue)
                        .frame(minHeight: 200)
                        .background(viewModel.roleVideos.isEmpty
                                    ? Color.grayLight
                                    : Color.clear)
                        
                        // loading indicator at the bottom
                        ProgressView()
                            .padding(.vertical, 18)
                            .frame(width: .infinity)
                            .onAppear {
                                viewModel.loadNextExplorePage()
                            }
                        
                        Spacer()
                        
                    }
                }
            }
            .padding(.horizontal, 18)
            
            NavigationBar()
                .background(.black)
        }
    }
    
    @ViewBuilder
    private func rolesCarousel(roleVideo: RoleVideo) -> some View {
        VStack(alignment: .leading) {
            // title
            HStack {
                VStack {
                    Text("ROLE")
                        .foregroundColor(.primaryPurpleLight)
                    Text(roleVideo.role)
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
            VStack {
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
        VStack(alignment: .leading, spacing: 8) {
            // title
            HStack {
                VStack {
                    Text("TOPIC")
                        .foregroundColor(.primaryPurpleLight)
                    Text(topicVideo.topic)
                        .font(.H4)
                }
                Spacer()
                NavigationLink {
                    
                } label: {
                    Text("See more")
                        .font(.small)
                        .foregroundStyle(Color.primaryPurple)
                }
            }
            
            // playlist previews
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(topicVideo.videos) { playlist in
                        PlaylistPreviewCard(playlist: playlist)
                    }
                }
            }
        }
        .border(.pink)
        .frame(minHeight: 40)
        .border(.blue)
    }

    @ViewBuilder
    func singlePlaylist(playlist: PlaylistPreview) -> some View {
        HStack {
            // image
            if let imageStringURL = playlist.thumbnailURL,
               let imageURL = URL(string: imageStringURL) {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipped()
                    
                } placeholder: {
                    Rectangle()
                        .foregroundStyle(Color.grayNeutral)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 60)
                }
            } else {
                Rectangle()
                    .foregroundStyle(Color.grayNeutral)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
            }
            
            // title
            
            VStack(alignment: .leading) {
                Text(playlist.title)
                    .font(.subtitle2)
                    .lineLimit(1)
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(playlist.description)
                    .font(.body2)
                    .lineLimit(2)
                    .foregroundStyle(Color.grayNeutral)
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
//    MainExplorePage()
//        .environment(TabSelectionManager(selection: .Explore))
    ContentView()
}
