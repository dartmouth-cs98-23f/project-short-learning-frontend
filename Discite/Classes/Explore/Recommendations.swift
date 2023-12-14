//
//  Recommendations.swift
//  Discite
//
//  Created by Jessie Li on 11/9/23.
//

import Foundation

struct RecommendationsData: Decodable {
    var topics: [Topic]
    
    enum CodingKeys: String, CodingKey {
        case message
        case topics
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        topics = try container.decode([Topic].self, forKey: .topics)
    }
}

class Recommendations: ObservableObject {
    
    @Published var topics: [Topic]?
    @Published var fetchSuccessful: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case message
        case topics
    }
    
    func getTopics() -> [Topic]? {
        return topics
    }
    
    func load() async -> [Topic] {
        do {
            let topics = try await ExploreService.mockFetchTopics()
            return topics
        } catch {
            print("Failed to load topics: \(error)")
            return []
        }
    }
    
    // Calls endpoint for new recommendations
    func fetchRecommendations() {
        fetchSuccessful = false
        
        ExploreService.fetchRecommendations { recommendations in
            self.topics = recommendations.topics
            print("Recommendations loaded with \(recommendations.topics.count) topics.")
            self.fetchSuccessful = true
            
        } failure: { error in
            print("No recommendations: \(error)")
        }

    }
    
}
