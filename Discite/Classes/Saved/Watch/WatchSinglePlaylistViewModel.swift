//
//  WatchSinglePlaylistViewModel.swift
//  Discite
//
//  Created by Jessie Li on 3/9/24.
//

import Foundation

class WatchSinglePlaylistViewModel: ObservableObject {
    @Published var state: ViewModelState = .loading
    @Published var playlist: Playlist?
    
    private var task: Task<Void, Error>? {
        willSet {
            if let currentTask = task {
                if currentTask.isCancelled { return }
                currentTask.cancel()
                // Setting a new task cancelling the current task
            }
        }
    }
    
    init(playlistId: String) {
        task = Task {
            await load(playlistId: playlistId)
        }
    }
    
    @MainActor
    private func load(playlistId: String) async {
        do {
            self.playlist = try await VideoService.getSavedPlaylist(playlistId: playlistId)
            state = .loaded
            
        } catch {
            print("Error in WatchSinglePlaylistViewModel.load: \(error)")
            self.state = .error(error: error)
        }
    }
    
    deinit {
        task?.cancel()
    }
}
