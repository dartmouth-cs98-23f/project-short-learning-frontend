//
//  Recommender.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import Foundation
    
class Recommender: ObservableObject {
    
    var recommendations: Recommendations?
    
    // MARK: Initializers
    
    init() {
    
        ExploreService.fetchTestRecommendations { recommendations in
            self.recommendations = recommendations
        } failure: { error in
            print("Error fetching recommendations: \(error.localizedDescription)")
        }
    }
    
    // MARK: Getters
    
    func getTopics() -> [Topic]? {
        return recommendations?.topics
    }
    
}
