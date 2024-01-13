//
//  OnboardingViewModel.swift
//  Discite
//
//  Created by Colton Sankey on 11/8/23.
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    
    @Published var topics: [String] = []
    @Published var error: Error?
    @Published var internalError: String = ""
    @Published var videos: [Playlist] = []

    func send() async {
        self.internalError = ""
        if topics.count > 2 {
            let modifiedArray = topics.map { $0.lowercased().replacingOccurrences(of: " ", with: "") }
        print(modifiedArray)
            
            do {
                _ = try await AuthenticationService.onboard(
                    parameters: OnboardRequest(topics: modifiedArray)
                )
                
            } catch {
                self.error = error
                print("Onboarding failed: \(error)")
            }
            
        } else {
            self.internalError = "Please select at least 3 topics"
        }
    }
}
