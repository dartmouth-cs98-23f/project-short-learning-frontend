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
    @Published var state: PagingState
    
    let threshold: Int
    private var index: Int = 0
    
    private var currentTask: Task<Void, Never>? {
        willSet {
            if let task = currentTask {
                if task.isCancelled { return }
                print("CANCELING TASK.")
                task.cancel()
                // Setting a new task cancelling the current task
            }
        }
    }
    
    init() {
        state = .loadingFirstPage
        threshold = 1
    }
    
    public func onItemAppear(playlist: Playlist) {
        
        // (1) Appeared: Already loading
        if state == .loadingNextPage || state == .loadingFirstPage {
            print("STATUS: Already loading.")
            return
        }
        
        // (2) No index
        guard let index = items.firstIndex(where: { $0.id == playlist.id }) else {
            print("BAD: No match.")
            return
        }
        
        print("STATUS: Saw ITEM \(index). Total length: \(items.count)")

        // (3) Appeared: Threshold not reached
        let thresholdIndex = items.index(items.endIndex, offsetBy: -threshold)
        if index != thresholdIndex {
            print("OK: Enough playlists in queue.")
            return
        }
        
        print("LOADING NEXT.")
        // (4) Appeared: Load next page
        state = .loadingNextPage
        currentTask = Task {
            await load()
        }
    }
    
    public func load() async {
        do {
            // (1) Ask for more playlists
            let newItems = try await VideoService.mockFetchSequence()
            
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
                print("OK: Loaded. NEW TOTAL LENGTH: \(items.count)")
            }
            
        } catch {
            print("Error: Sequence 'load' failed. [\(error)]")
            
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

extension SequenceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptySequence:
            return NSLocalizedString("Error.SequenceError.EmptySequence", comment: "Sequence error")
        case .indexOutOfRange:
            return NSLocalizedString("Error.SequenceError.IndexOutOfRange", comment: "Sequence error")
        }
    }
}
