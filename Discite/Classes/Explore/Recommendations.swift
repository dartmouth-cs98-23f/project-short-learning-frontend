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
    
    @Published private(set) var topics: [Topic] = []
    
    func load() async {
        topics = await ExploreService.loadTopics()
    }
}
