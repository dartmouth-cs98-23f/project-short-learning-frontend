//
//  ExploreService.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import Foundation
import SwiftUI

class ExploreService {
    
    static let shared: ExploreService = ExploreService()
    
    static func fetchTestRecommendations() -> Recommendations? {
        
        print("Fetching test recommendations...")

        do {
            let recommendations = try getSampleData(Recommendations.self,
                                        forResource: "samplerecommendations",
                                        withExtension: "json")
            
            print("Got sample recommendations, returning it.")
            return recommendations
            
        } catch {
            print("Couldn't get sample recommendations: \(error)")
            return nil
        }
    }
    
    static func fetchTestTopic() -> Topic? {
        
        print("Fetching test topic...")
        
        do {
            let topic = try getSampleData(Topic.self, forResource: "sampletopic", withExtension: "json")
            
            print("Got sample topic, returning it.")
            return topic
            
        } catch {
            print("Couldn't get sample topic: \(error)")
            return nil
        }
    }
}
