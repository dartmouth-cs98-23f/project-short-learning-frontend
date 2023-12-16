//
//  ExploreService.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import Foundation
import SwiftUI

class ExploreService {
    
    static func loadTopics() async -> [Topic] {
        do {
            let topics = try await ExploreService.mockFetchTopics()
            return topics
        } catch {
            print("Failed to load topics: \(error)")
            return []
        }
    }
    
    static func mockFetchTopics() async throws -> [Topic] {
        print("TEST: Fetching topics...")
        
        let recommendationsData = try await APIRequest<EmptyRequest, RecommendationsData>
            .mockAPIRequest(RecommendationsData.self,
                            forResource: "samplerecommendations",
                            withExtension: "json")
        
        return recommendationsData.topics
    }
    
}
