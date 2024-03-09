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
            let tabItems: [CustomTabItem] = [
                CustomTabItem("Playlists") {
                    playlistsPage()
                },
                CustomTabItem("Topics") {
                    topicsPage()
                }
            ]
            
            // tab view
            CustomTabView(tabItems)
            
            Spacer()
        }
        .padding(.horizontal, 18)
        .onAppear {
            // Filter out topics that were unsaved
            if !viewModel.savedTopics.isEmpty {
                viewModel.filterSavedTopics()
            }
        }
        .animation(.smooth, value: viewModel.savedPlaylists.isEmpty)
        
        NavigationBar()
    }
    
    @ViewBuilder
    func topicsPage() -> some View {
        if case .loading = viewModel.state {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        } else if case .error = viewModel.state {
            Text("Couldn't load saved playlists.")
            
        } else {
            ScrollView(.vertical) {
                VStack(spacing: 18) {
                    ForEach(viewModel.savedTopics) { topic in
                        singleTopic(topic: topic)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func playlistsPage() -> some View {
        if case .loading = viewModel.state {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        } else if case .error = viewModel.state {
            Text("Couldn't load saved topics.")
            
        } else {
            ScrollView(.vertical) {
                VStack(spacing: 8) {
                    ForEach(viewModel.savedPlaylists) { playlist in
                        singlePlaylist(playlist: playlist)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func singleTopic(topic: TopicTag) -> some View {
        NavigationLink {
            TopicPageView(topicSeed: topic)
            
        } label: {
            HStack {
                Image(systemName: "tag")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(topic.topicName)
                    .font(.H6)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
            }
            .padding(12)
            .foregroundStyle(Color.primaryBlueBlack)
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
                .lineLimit(1)
                .padding(.horizontal, 8)
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
        .environmentObject(User())
        .environment(TabSelectionManager(selection: .Saved))
}
