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
            Hello()
                .transition(transition)
                .environmentObject(user)
            
        case .signedOut:
            MainAuthPage()
                .transition(transition)
                .environmentObject(user)
        }
    }
}

#Preview {
    ContentView()
}
