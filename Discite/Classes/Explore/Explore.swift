//
//  Explore.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import Foundation
    
class Explore: ObservableObject {
    
    var recommendations: Recommendations?
    
    // MARK: Initializers
    
    init() {
    
        ExploreService.fetchTestRecommendations { recommendations in
            self.recommendations = recommendations
        } failure: { error in
            print("\(error.localizedDescription)")
        }
    }
    
    // MARK: Getters
    
    func getTopics() -> [Topic]? {
        return recommendations?.topics
    }
    
}
