//
//  WatchSinglePlaylist.swift
//  Discite
//
//  Created by Jessie Li on 3/9/24.
//

import SwiftUI

struct WatchSinglePlaylist: View {
    @StateObject var viewModel: WatchSinglePlaylistViewModel

    init(playlistId: String) {
        self._viewModel = StateObject(
            wrappedValue: WatchSinglePlaylistViewModel(playlistId: playlistId))
    }

    var body: some View {
        Group {
            if case .error = viewModel.state {
                ErrorView(text: "Failed to load saved playlist.")

            } else if let playlist = viewModel.playlist {
                SinglePlaylistWatchRepresentable(playlist: playlist)

            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tint(.white)
                    .background(.black)
            }
        }
        .background(Color.black)
    }
}

#Preview {
    WatchSinglePlaylist(playlistId: "65d8fc3495f306b28d1b88d6")
        .environment(TabSelectionManager.init(selection: .Saved))
}
