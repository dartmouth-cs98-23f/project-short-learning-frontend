//
//  ExploreService.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import Foundation

class ExploreService {
    
    static let shared: ExploreService = ExploreService()
    
    static func fetchTestRecommendations(completion: @escaping (Recommendations) -> Void,
                                         failure: @escaping (APIError) -> Void) {
        
        print("Fetching test recommendations...")
        
        do {
            let recommendations = try getSampleData(Recommendations.self,
                                        forResource: "recommendationssample",
                                        withExtension: "json")
            
            print("Got sample recommendations, returning it.")
            completion(recommendations)
            
        } catch {
            print("Couldn't get sample recommendations: \(error)")
        }
    }
    
    static func fetchTestTopic(completion: @escaping (Topic) -> Void,
                               failure: @escaping (APIError) -> Void) {
        
        print("Fetching test topic...")
        
        do {
            let topic = try getSampleData(Topic.self, forResource: "topicsample", withExtension: "json")
            
            print("Got sample topic, returning it.")
            completion(topic)
            
        } catch {
            print("Couldn't get sample topic: \(error)")
        }
    }
}
