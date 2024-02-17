//
//  TopicPageView.swift
//  Discite
//
//  Created by Bansharee Ireen on 1/26/24.
//  Updated by Jessie Li on 2/14/24.
//

import SwiftUI

struct TopicPageView: View {
    @Binding var topicSeed: TopicTag
    @State private var toast: Toast?
    
    @StateObject var viewModel = TopicViewModel()
    
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 2), GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        if let topic = viewModel.topic {
            ScrollView(.vertical) {
                VStack(spacing: 24) {
                    topicHeader()
                        .padding(.horizontal, 18)

                    topicDescription(description: topic.description, 
                                     rolesData: topic.spiderGraphData)
                        .padding(.horizontal, 18)
                    
                    playlistGrid(playlistPreviews: topic.playlistPreviews)
                }
                .padding(.bottom, 18)
            }
            .ignoresSafeArea(edges: [.bottom, .horizontal])
            .navigationBarTitleDisplayMode(.inline)
            .toastView(toast: $toast)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // bookmark
                    Button {
                        topicSeed.isSaved.toggle()
                        
                        Task {
                            await viewModel.mockSaveTopic(
                                parameters: SaveTopicRequest(
                                    topicId: topicSeed.topicId,
                                    saved: topicSeed.isSaved))
                        }
                        
                        if topicSeed.isSaved {
                            toast = Toast(style: .success, message: "Saved.")
                        }
            
                    } label: {
                        Image(systemName: topicSeed.isSaved ? "bookmark.fill" : "bookmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.primaryBlueBlack)
                    }
                }
            }
            
        } else {
            ProgressView()
                .containerRelativeFrame([.horizontal, .vertical])
                .task {
                    await viewModel.mockGetTopic(topicId: topicSeed.topicId)
                }
    
        }
    }
    
    @ViewBuilder
    func topicHeader() -> some View {
        VStack {
            HStack(spacing: 4) {
                Image(systemName: "tag")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                
                Text("TOPIC")
            }
            .foregroundColor(.primaryPurpleLight)
            
            Text(topicSeed.topicName)
                .font(.H3)
                .foregroundStyle(Color.primaryBlueBlack)
            
        }
    }
    
    @ViewBuilder
    func topicDescription(description: String?, rolesData: RolesResponse) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(Font.H5)
            
            Text(description ?? "No description available.")
                .font(.body2)
                .multilineTextAlignment(.leading)
            
            // "See roles" button
            ToggleRoles(spiderGraphData:
                SpiderGraphData(data: [SpiderGraphEntry(
                        values: rolesData.values,
                        color: .secondaryPink)],
                    axes: rolesData.roles,
                    color: .grayNeutral, 
                    titleColor: .gray, bgColor: .white))
            
        }
        .frame(minHeight: 48)
    }
    
    @ViewBuilder
    func playlistGrid(playlistPreviews: [PlaylistPreview]) -> some View {
        VStack(alignment: .leading) {
            Text("Playlists").font(Font.H5)
                .padding(.horizontal, 18)
            
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(playlistPreviews) { playlist in
                    PlaylistPreviewCard(playlist: playlist)
                }
            }
        }
    }
}

struct ToggleRoles: View {
    var spiderGraphData: SpiderGraphData
    
    @State private var rolesVisible = false

    var body: some View {
        VStack(alignment: .leading) {
            
            Button {
                withAnimation(.smooth(duration: 0.4)) {
                    self.rolesVisible.toggle()
                }
            } label: {
                Text(rolesVisible ? "Hide roles" : "See roles")
                    .font(.button)
            }
            
            if rolesVisible {
                spiderGraph()
            }
        }
    }
    
    @ViewBuilder
    func spiderGraph() -> some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                let center = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)

                SpiderGraph(
                    axes: spiderGraphData.axes,
                    values: spiderGraphData.data,
                    textColor: spiderGraphData.titleColor,
                    center: center,
                    radius: 125
                )
            }
        }
        .frame(minHeight: 350)
    }
}

#Preview {
    ExploreView()
        .environment(TabSelectionManager(selection: .Explore))
}
