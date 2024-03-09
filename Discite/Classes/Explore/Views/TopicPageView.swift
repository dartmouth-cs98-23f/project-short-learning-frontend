//
//  TopicPageView.swift
//  Discite
//
//  Created by Bansharee Ireen on 1/26/24.
//  Updated by Jessie Li on 2/14/24.
//

import SwiftUI

struct TopicPageView: View {
    @State var topicSeed: TopicTag
    @StateObject var viewModel: TopicViewModel
    
    init(topicSeed: TopicTag) {
        self._topicSeed = State(initialValue: topicSeed)
        self._viewModel = StateObject(
            wrappedValue: TopicViewModel(topicId: topicSeed.topicId))
    }
    
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 2), GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        if case .loading = viewModel.state {
            ProgressView()
                .containerRelativeFrame([.horizontal, .vertical])
            
        } else if case .error(let error) = viewModel.state,
                  error as? TopicError == TopicError.getTopic {
            Text("Error getting topic page.")
                .foregroundStyle(Color.pink)
                .containerRelativeFrame([.horizontal, .vertical])
            
        } else {
            ScrollView(.vertical) {
                VStack(spacing: 24) {
                    topicHeader()
                        .padding(.horizontal, 18)

                    topicDescription(
                        description: viewModel.description,
                        values: viewModel.graphValues,
                        roles: viewModel.roles)
                        .padding(.horizontal, 18)
                    
                    playlistGrid(playlistPreviews: viewModel.playlists)
                }
                .padding(.bottom, 18)
            }
            .ignoresSafeArea(edges: [.bottom, .horizontal])
            .navigationBarTitleDisplayMode(.inline)
            .toastView(toast: $viewModel.toast)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // bookmark
                    Button {
                        Task {
                            if !topicSeed.isSaved {
                                await viewModel.saveTopic(
                                    parameters: SaveTopicRequest(
                                        topicId: topicSeed.topicId,
                                        saved: topicSeed.isSaved))
                            }
                            
                            if case .error = viewModel.state {
                            } else {
                                topicSeed.isSaved.toggle()
                            }
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
    func topicDescription(description: String?, values: [CGFloat], roles: [String]) -> some View {
        let topicData = viewModel.makeSpiderGraphEntry(for: .topic)
        let userData = viewModel.makeSpiderGraphEntry(for: .user)
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(Font.H5)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(description ?? "No description available.")
                .font(.body2)
                .multilineTextAlignment(.leading)
            
            // "See roles" button
            ToggleRoles(spiderGraphData:
                SpiderGraphData(data: [topicData, userData],
                    axes: roles,
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
                HStack {
                    Circle()
                        .fill(Color.primaryPurpleLight)
                        .frame(width: 12, height: 12)
                    
                    Text("Me")
                        .font(.body1)
                }
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
    TopicPageView(topicSeed: TopicTag(
        id: UUID(),
        topicId: "12",
        topicName: "Algorithms")
    )
    .environment(TabSelectionManager(selection: .Explore))
    .environmentObject(User())
}
