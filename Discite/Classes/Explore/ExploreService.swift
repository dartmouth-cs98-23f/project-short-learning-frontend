//
//  ExploreService.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import Foundation
import SwiftUI

class ExploreService {
    
    static func fetchRecommendations(completion: @escaping (RecommendationsData) -> Void,
                                     failure: @escaping (APIError) -> Void) {
        
        print("Fetching recommendations...")
        let path = "/api/recommendations/topics"
        let method: HTTPMethod = .get
        
        APIRequest<LoginRequest, AuthResponseData>.call(
            scheme: APIConfiguration.scheme,
            host: APIConfiguration.host,
            path: path,
            port: APIConfiguration.port,
            method: method,
            authorized: true) { data in
                
                do {
                    print("Explore Service received data from APIRequest, decoding.")
                    let decoder = CustomJSONDecoder.shared
                    let recommendations = try decoder.decode(RecommendationsData.self, from: data)
                    completion(recommendations)
                    
                } catch {
                    print(String(describing: error))
                }
                
            } failure: { error in
                failure(error)
            }
        }
    
    static func fetchTestRecommendations() -> Recommendations? {
        
        print("Fetching test recommendations...")

        do {
            let recommendationsData = try getSampleData(RecommendationsData.self,
                                        forResource: "samplerecommendations",
                                        withExtension: "json")
            
            let recommendations = Recommendations()
            recommendations.fetchSuccessful = true
            recommendations.topics = recommendationsData.topics
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
            return topic
            
        } catch {
            print("Couldn't get sample topic: \(error)")
            return nil
        }
    }
    
}
