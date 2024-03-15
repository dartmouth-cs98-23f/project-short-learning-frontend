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

    @State var seed: String?

    @Environment(\.isSearching)
    private var isSearching: Bool

    var body: some View {
            VStack(alignment: .leading) {
                ScrollView(.vertical, showsIndicators: false) {
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
                        .clipped()
                }
            }

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
            }
            .padding(.horizontal, 18)

            // playlists
            VStack(alignment: .leading, spacing: 12) {
                ForEach(roleVideo.videos) { playlist in
                    NavigationLink {
                        WatchFullScreenCover(seed: playlist.playlistId)
                    } label: {
                        singlePlaylist(playlist: playlist)
                    }
                }
            }
        }
        .padding(.bottom, 12)
    }

    @ViewBuilder
    private func topicCarousel(topicVideo: TopicVideo) -> some View {
        VStack(alignment: .leading, spacing: 4) {
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
            .padding(.horizontal, 18)

            // playlist previews
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    ForEach(topicVideo.videos) { playlist in
                        ExplorePlaylistPreviewCard(
                            playlist: playlist,
                            seed: seed)
                            .padding(.vertical, 18)
                    }
                }
            }
            .padding(.horizontal, 18)
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
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipped()

                } placeholder: {
                    ProgressView()
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .frame(width: 60, height: 60)

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
            Image(systemName: "play.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundStyle(Color.primaryBlueBlack)
                .padding(4)
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.grayDark.opacity(0.3), radius: 8, x: 2, y: 2)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 4)
    }
}

#Preview {
    MainExplorePageSearchWrapper()
        .environment(TabSelectionManager(selection: .Explore))
        .environmentObject(User())
}
