//
//  SavedPage.swift
//  Discite
//
//  Created by Jessie Li on 2/9/24.
//

import SwiftUI

enum SavedTab {
    case playlists, topics
}

struct SavedPage: View {
    @StateObject var viewModel = SavedViewModel()
    @State var selectedTab: SavedTab = .playlists
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 18) {
            Text("Saved")
                .font(.H2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // tabs
            HStack(alignment: .center) {
                Button {
                    selectedTab = .playlists
                } label: {
                    Text("Playlists")
                        .font(selectedTab == .playlists ? .H5 : .H6)
                        .foregroundStyle(selectedTab == .playlists ? Color.primaryPurple : Color.primaryPurpleLight)
                        .overlay(
                            Rectangle()
                                .fill(selectedTab == .playlists ? Color.primaryPurple : Color.clear)
                                .frame(height: 2), alignment: .bottom
                        )
                }
                
                Button {
                    selectedTab = .topics
                } label: {
                    Text("Topics")
                        .font(selectedTab == .topics ? .H5 : .H6)
                        .foregroundStyle(selectedTab == .topics ? Color.primaryPurple : Color.primaryPurpleLight)
                        .overlay(
                            Rectangle()
                                .fill(selectedTab == .topics ? Color.primaryPurple : Color.clear)
                                .frame(height: 2), alignment: .bottom
                        )
                }
                
            }
            
            if viewModel.error == nil && viewModel.savedPlaylists.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .border(.pink)
                    .task {
                        await viewModel.mockGetSaved()
                    }
                
            } else if viewModel.error != nil {
                Text("Couldn't load saved content.")
                
            } else {
                switch selectedTab {
                case .playlists:
                    ScrollView(.vertical) {
                        VStack(spacing: 8) {
                            ForEach(viewModel.savedPlaylists) { playlist in
                                singlePlaylist(playlist: playlist)
                            }
                        }
                    }
                case .topics:
                    ScrollView(.vertical) {
                        VStack(spacing: 18) {
                            ForEach($viewModel.savedTopics) { $topic in
                                singleTopic(topic: $topic)
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 18)
        .border(.blue)
    }
    
    @ViewBuilder
    func singleTopic(topic: Binding<TopicTag>) -> some View {
        NavigationLink {
            TopicPageView(topicSeed: topic)
            
        } label: {
            HStack {
                Image(systemName: "tag")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(topic.wrappedValue.topicName)
                    .font(.H6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
            }
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.primaryPurpleLightest)
                    .strokeBorder(Color.primaryPurpleLight, lineWidth: 2)
            }
        }
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
            Text(playlist.title)
                .font(.subtitle2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
    SavedPage()
}
