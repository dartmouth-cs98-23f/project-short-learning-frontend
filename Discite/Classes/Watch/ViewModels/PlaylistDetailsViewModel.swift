//
//  PlaylistDetailsViewModel.swift
//  Discite
//
//  Created by Jessie Li on 3/3/24.
//

import Foundation

@MainActor
class PlaylistDetailsViewModel: ObservableObject {
    @Published var summary: PlaylistInferenceSummary?
    @Published var state: ViewModelState = .loading

    private var playlist: Playlist

    init(playlist: Playlist) {
        self.playlist = playlist
        getPlaylistSummary()
    }

    public func getPlaylistSummary() {
        self.state = .loading

        Task {
            do {
                summary = try await VideoService.getPlaylistSummary(playlistId: playlist.playlistId)
                self.state = .loaded

            } catch {
                print("Error in PlaylistDetailsViewModel.getPlaylistSummary: \(error)")
                self.state = .error(error: error)
            }
        }
    }
}
