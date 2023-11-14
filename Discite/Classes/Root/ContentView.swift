//
//  ContentView.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var auth = Auth.shared
    // @StateObject var sequence = Sequence()
    // @StateObject var recommendations = Recommendations()
    
    init() { }
    
    var body: some View {
        NavigationView {
            if Auth.shared.loggedIn {
                if Auth.shared.onboarded {
                    Navigator()
                        // .environmentObject(sequence)
                        // .environmentObject(recommendations)
                } else {
                    OnboardingView()
                }
            } else {
                // SignupView()
                LoginPlaceholder()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
