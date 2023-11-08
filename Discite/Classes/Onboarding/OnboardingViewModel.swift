//
//  OnboardingViewModel.swift
//  Discite
//
//  Created by Colton Sankey on 11/8/23.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    
    @Published var topics: [String] = []
    @Published var error: APIError?
    
    func send() {
        AuthenticationService.OnboardService(
            parameters: OnboardRequest(
                topics: topics
            )
        ).call { response in
            self.error = nil
            print(self.topics)
            do {
                try Auth.shared.setToken(token: response.token) // Fix here
            } catch {
                print("Error: Unable to set preferences")
            }
            
        } failure: { error in
            self.error = error
        }
    }
}
