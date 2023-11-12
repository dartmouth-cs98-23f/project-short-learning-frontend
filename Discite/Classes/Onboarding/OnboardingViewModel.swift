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
        ).call { _ in
            self.error = nil
            print(self.topics)
        } failure: { error in
            self.error = error
        }
    }
}
