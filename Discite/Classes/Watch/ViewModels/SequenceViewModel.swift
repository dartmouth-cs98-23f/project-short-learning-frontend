//
//  SequenceViewModel.swift
//  Discite
//
//  Created by Jessie Li on 1/23/24.
//  Source: https://medium.com/whatnot-engineering/the-next-page-8950875d927a
//

import Foundation

class SequenceViewModel: ObservableObject {
    @Published var items: [Playlist] = []
    @Published var state: ViewModelState
    
    var seedPlaylist: PlaylistPreview?
    let threshold: Int
    private var index: Int = 0
    
    private var currentTask: Task<Void, Never>? {
        willSet {
            if let task = currentTask {
                if task.isCancelled { return }
                task.cancel()
                // Setting a new task cancelling the current task
            }
        }
    }
    
    init(seed: PlaylistPreview? = nil) {
        state = .loading
        threshold = 1
        seedPlaylist = seed
        
        Task {
            await self.load()
            state = .loaded
        }
    }
    
    @MainActor
    public func setSeed(seed: PlaylistPreview?) {
        seedPlaylist = seed
    }
    
    public func onItemAppear(playlist: Playlist) {
        
        // (1) Appeared: Already loading
        if case .loading = state {
            return
        }
        
        // (2) No index
        guard let index = items.firstIndex(where: { $0.id == playlist.id }) else {
            return
        }
        
        print("\tSequenceViewModel: Saw ITEM \(index). Total length: \(items.count)")

        // (3) Appeared: Threshold not reached
        let thresholdIndex = items.index(items.endIndex, offsetBy: -threshold)
        if index != thresholdIndex {
            return
        }
        
        print("\tLOADING NEXT.")
        // (4) Appeared: Load next page
        state = .loading
        currentTask = Task {
            await load()
        }
    }
    
    public func load() async {
        do {
            // (1) Ask for more playlists
            // let newItems = try await VideoService.getSequence(playlistId: seedPlaylist?.playlistId)
            print("Getting sequence with seed: \(seedPlaylist?.playlistId ?? "None")")
            let newItems = try await VideoService.getSequence(playlistId: seedPlaylist?.playlistId)
            // clear seed
            await self.setSeed(seed: nil)
            
            if newItems.isEmpty {
                throw SequenceError.emptySequence
            }
            
            for playlist in newItems {
                playlist.sequenceIndex = index
                index += 1
            }
            
            // (2) Task has been cancelled
            if Task.isCancelled { return }
            
            // (3) Append to the existing set of items
            let allItems = items + newItems
            
            // (4) Publish our changes to SwiftUI by setting our items and state
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.items = allItems
                self.state = .loaded
                print("\tSequenceViewModel: OK, loaded. NEW LENGTH: \(items.count)")
            }
            
        } catch {
            print("Error in Sequence.load [\(error)]")
            
            // (5) Publish error to SwiftUI
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .error(error: error)
            }
        }

    }
}

enum SequenceError: Error {
    case emptySequence
    case indexOutOfRange
}
