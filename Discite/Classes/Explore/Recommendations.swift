//
//  Recommendations.swift
//  Discite
//
//  Created by Jessie Li on 11/9/23.
//

import Foundation

class Recommendations: Decodable, ObservableObject {
    
    var topics: [Topic]
    
    enum CodingKeys: String, CodingKey {
        case message
        case topics
    }
    
    // MARK: Initializer
    
    required init(from decoder: Decoder) throws {
        print("Decoding recommendations...")
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        topics = try container.decode([Topic].self, forKey: .topics)
    }
    
    // MARK: Public Methods
    
    func getTopics() -> [Topic] {
        return topics
    }
    
    // Calls endpoint for new recommendations
    func updateRecommendations() {
        // Placeholder for now
    }
    
}
