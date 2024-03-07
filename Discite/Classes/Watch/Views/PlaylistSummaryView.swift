//
//  PlaylistSummaryView.swift
//  Discite
//
//  Created by Jessie Li on 3/3/24.
//

import SwiftUI

struct PlaylistSummaryView: View {
    @StateObject var viewModel: PlaylistDetailsViewModel
    @ObservedObject private var playlist: Playlist
    
    @State private var isShareShowing: Bool = false
    @State private var totalHeight = CGFloat.zero
    
    init(playlist: Playlist) {
        self.playlist = playlist
        self._viewModel = StateObject(wrappedValue: PlaylistDetailsViewModel(playlist: playlist))
    }
    
    var body: some View {
        if case .error = viewModel.state {
            ErrorView(text: "Error getting summary.")
            
        } else if case .loaded = viewModel.state,
                  let summary = viewModel.summary {
            
            GeometryReader { geo in
                ScrollView(.vertical) {
                    VStack(spacing: 18) {
                        // playlist details
                        playlistDetails()
                        
                        Divider()
                        
                        // introduction
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Summary")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.H5)
                            Text(summary.introduction)
                                .font(.body2)
                        }
                        
                        Divider()
                        
                        // topics
                        VStack(spacing: 8) {
                            Text("Topics")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.H5)
                            topicCloud(in: geo, topics: summary.topics)
                        }
                        
                        Divider()
                        
                        // key points
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Key points")
                                .font(.H5)
                            ForEach(summary.sections) { section in
                                sectionView(section: section)
                            }
                        }
                        
                    }
                }
            }
            .padding(18)
            .sheet(isPresented: $isShareShowing) {
                Share(playlist: playlist, isShowing: $isShareShowing)
            }
            
        } else {
            ProgressView()
                .containerRelativeFrame([.vertical, .horizontal])
        }
    }
    
    @ViewBuilder
    private func playlistDetails() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(playlist.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.H3)
            
            // Author details
            HStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .font(.title)
                
                Text(playlist.authorUsername)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.subtitle2)
                    .lineLimit(1)
                    .clipped()
            }
            .foregroundStyle(Color.primaryBlueBlack)
        
        }
        .font(.title2)

    }
    
    @ViewBuilder
    private func sectionView(section: PlaylistInferenceSummary.Section) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(section.title)
                .font(.H6)
                .foregroundStyle(Color.primaryPurple)
            
            ForEach(section.content, id: \.self) { bullet in
                HStack(alignment: .top) {
                    Text("•")
                        .font(.small)
                    Text("\(bullet)")
                        .multilineTextAlignment(.leading)
                        .font(.body2)
                }
            }
        }
    }
    
    @ViewBuilder
    private func topicTag(_ title: String) -> some View {
        Text(title)
            .font(.body2)
            .foregroundStyle(Color.primaryPurple)
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.primaryPurple, lineWidth: 2)
            }
    }
    
    // stackoverflow.com/questions/62102647
    @ViewBuilder
    private func topicCloud(in geometry: GeometryProxy, topics: [String]) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        let horizontalSpacing: CGFloat = 4
        let verticalSpacing: CGFloat = 4
        
        ZStack(alignment: .topLeading) {
             ForEach(topics, id: \.self) { topic in
                topicTag(topic)
                    .padding(.horizontal, horizontalSpacing)
                    .padding(.vertical, verticalSpacing)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0
                            height -= dimension.height
                        }
                        let result = width
                        if topic == topics.last! {
                            width = 0 // last item
                        } else {
                            width -= dimension.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if topic == topics.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
        
    }
    
    @ViewBuilder
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

#Preview {
    let playlist = Playlist()
    
    return PlaylistSummaryView(playlist: playlist)
}
