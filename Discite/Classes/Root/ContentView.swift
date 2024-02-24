//
//  ContentView.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @ObservedObject var authViewModel = AuthViewModel.shared
    
    let transition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading))
        
    var body: some View {
        switch authViewModel.status {
        case .loggedIn:
            Navigator()
                .transition(transition)
            
        case .onboarding:
            OnboardingPage()
                .transition(transition)
            
        case .loggedOut:
            GoogleLogin()
                .transition(transition)
        }
    }
}

#Preview {
    ContentView()
}
