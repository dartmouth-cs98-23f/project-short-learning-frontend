//
//  SearchHistoryStore.swift
//  Discite
//
//  Created by Bansharee Ireen on 2/29/24.
//

import Foundation

@MainActor
class HistoryStore: ObservableObject {
    @Published var history: [String] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("history.data")
    }
    
    func load() async throws {
        let task = Task<[String], Error> {
            let fileURL = try Self.fileURL()
            
            // optionally load the file data
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            
            let currHistory = try JSONDecoder().decode([String].self, from: data)
            return currHistory
        }
        
        let history = try await task.value
        self.history = history
    }
    
    func save(newHistory: [String]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(newHistory)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        
        // wait for task to run
        _ = try await task.value
    }
}
