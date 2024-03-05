//
//  SearchDestinationView.swift
//  Discite
//
//  Created by Bansharee Ireen on 2/13/24.
//

import SwiftUI

struct SearchDestinationView: View {
    var searchText: String
    var searchables: [Searchable]
    var playlists: [Searchable]     // extracted playlists
    var topics: [Searchable]        // extracted topics
    
    init(searchText: String, searchables: [Searchable]) {
        self.searchText = searchText
        self.searchables = searchables
        self.playlists = searchables.filter { $0.type == .playlist }
        self.topics = searchables.filter { $0.type == .topic }
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Results")
                .font(Font.H2)
                
                Text(searchText)
                    .font(.H3)
                
                let tabItems: [CustomTabItem] = [
                    CustomTabItem("Playlists") {
                        playlistResults()
                    },
                    CustomTabItem("Topics") {
                        topicResults()
                    },
                    CustomTabItem("Accounts") {
                        Text("No Account results.")
                    }
                ]

                CustomTabView(tabItems)
            }
            .padding(18)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func playlistResults() -> some View {
        let results = playlists.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        
        if results.isEmpty && playlists.isEmpty {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if results.isEmpty {
            Text("No playlist results.")
        } else {
            ScrollView(.vertical) {
                VStack(spacing: 8) {
                    ForEach(results.indices, id: \.self) { index in
                        singlePlaylist(playlist: results[index].playlist!)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func topicResults() -> some View {
        let results = topics.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        
        if results.isEmpty && topics.isEmpty {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if results.isEmpty {
            Text("No topic results.")
        } else {
            ScrollView(.vertical) {
                VStack(spacing: 8) {
                    ForEach(results.indices, id: \.self) { index in
                        singleTopic(topic: results[index].topic!)
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
