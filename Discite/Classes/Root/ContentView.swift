//
//  ContentView.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var auth = Auth.shared
    @StateObject var sequence = VideoService.fetchTestSequence()!
    @StateObject var recommendations = ExploreService.fetchTestRecommendations()!
    
    var body: some View {
        if auth.loggedIn {
            if auth.onboarded {
                Navigator()
                    .environmentObject(sequence)
                    .environmentObject(recommendations)
            } else {
                OnboardingView()
            }
        } else {
            SignupView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
