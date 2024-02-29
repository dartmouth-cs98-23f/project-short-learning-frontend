//
//  OnboardViewModel.swift
//  Discite
//
//  Created by Jessie Li on 2/23/24.
//

import Foundation

@MainActor
class OnboardViewModel: ObservableObject {
    @Published var error: Error?
    
    // experience
    @Published var complexity: Double = 0.50
    
    // topics
    @Published var topics: [OnboardingTopic] = OnboardingTopic.defaults()
    
    // spider
    @Published var resetGraph: Bool = false
    var values: [CGFloat] = [0.8, 0.8, 1.0, 0.7, 0.9, 0.75]
    let defaultValues: [CGFloat] = [0.8, 0.8, 1.0, 0.7, 0.9, 0.75]
    let roles: [String] = ["Front", "Backend", "ML", "AI/Data", "DevOps", "QA"]
    
    public func resetGraphValues() {
        values = defaultValues
        resetGraph.toggle()
    }
    
    // POST onboarding
    public func mockOnboard(user: User) async {
        error = nil
        
        let filteredTopics = topics.compactMap { topic in
            topic.selected ? topic.title : nil
        }
        
        print("Filtered topics: \(filteredTopics)")
        
        let onboardRequest = OnboardRolesRequest(complexity: complexity,
                                                 topics: filteredTopics,
                                                 roles: roles,
                                                 values: values)
        
        do {
            print("TEST: POST onboard")
            _ = try await APIRequest<OnboardRolesRequest, EmptyResponse>
                .mockRequest(method: .post,
                             authorized: false,
                             path: "/api/onboard",
                             parameters: onboardRequest,
                             headers: [:])
            
            user.completeOnboarding()
            
        } catch {
            self.error = error
            print("Error in OnboardViewModel.mockOnboard: \(error)")
        }
    }
}

struct OnboardRolesRequest: Codable {
    var complexity: Double
    var topics: [String]
    var roles: [String]
    var values: [CGFloat]
}
