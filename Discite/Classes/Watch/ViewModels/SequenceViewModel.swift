//
//  SequenceViewModel.swift
//  Discite
//
//  Created by Jessie Li on 1/23/24.
//  Source: https://medium.com/whatnot-engineering/the-next-page-8950875d927a
//

import Foundation
import IGListKit

class SequenceViewModel: ObservableObject {
    @Published var items: [Playlist] = []
    @Published var state: ViewModelState
    
    var loadDelegate: SequenceLoadDelegate?
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
    
    init(seed: String? = nil) {
        state = .loading
        threshold = 1
        
        Task {
            await self.load(seed: seed)
            state = .loaded
        }
    }
    
    public func onItemAppear(index: Int) {
        print("\tSequenceViewModel: Saw ITEM \(index). Total length: \(items.count)")
        
        // (1) Appeared: Already loading
        if case .loading = state {
            return
        }
        
        // (2) Appeared: Threshold not reached
        let thresholdIndex = items.index(items.endIndex, offsetBy: -threshold)
        if index != thresholdIndex {
            return
        }
        
        // (3) Appeared: Load next page
        state = .loading
        currentTask = Task {
            await load()
        }
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
    
    @MainActor
    public func load(seed: String? = nil) async {
        do {
            // (1) Ask for more playlists
            // print("SequenceViewModel.load with seed: \(seedPlaylist?.playlistId ?? "None")")
            let newItems = try await VideoService.getSequence(playlistId: seed ?? "65d8fc3495f306b28d1b88d6")
            
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
            var allItems = items + newItems
            if allItems.count > 15 {
                allItems.removeFirst(5)
            }
            
            // (4) Publish our changes to SwiftUI by setting our items and state
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.items = allItems
                self.state = .loaded
                print("\tSequenceViewModel: OK, loaded. NEW LENGTH: \(items.count)")
                self.loadDelegate?.sequenceFinishedLoading(success: true, error: nil)
            }
            
        } catch {
            print("Error in Sequence.load [\(error)]")
            
            // (5) Publish error to SwiftUI
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .error(error: error)
                self.loadDelegate?.sequenceFinishedLoading(success: false, error: error)
            }
        }

    }
}

enum SequenceError: Error {
    case emptySequence
    case indexOutOfRange
}
