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
    @Published var error: APIError?
    @Published var internalError: String = ""
    @Published var videos: [Playlist] = []
   // @ObservedObject var sequence = ContentView.sequence
    
    func send() {
        self.internalError = ""
        if topics.count > 2 {
            let modifiedArray = topics.map { $0.lowercased().replacingOccurrences(of: " ", with: "") }
        print(modifiedArray)
            AuthenticationService.OnboardService(
                parameters: OnboardRequest(
                    topics: modifiedArray
               )
            ).call { response in
                self.error = nil
                print(self.topics)
                do {
                    self.videos = response.playlists
                    Auth.shared.onboarded = true
                    
                }
            } failure: { error in
                self.error = error
            }
        } else {
            self.internalError = "Please select at least 3 topics"
        }
    }
}
