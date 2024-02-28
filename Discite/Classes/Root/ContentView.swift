//
//  ContentView.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject var user = User()
    
    let transition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading))
        
    var body: some View {
        switch user.state {
        case .signedIn:
            Navigator()
                .transition(transition)
                .environmentObject(user)
            
        case .onboarding:
            OnboardingPage()
                .transition(transition)
                .environmentObject(user)
            
        case .signedOut:
            LoginPage()
                .transition(transition)
                .environmentObject(user)
        }
    }
}

#Preview {
    ContentView()
}
