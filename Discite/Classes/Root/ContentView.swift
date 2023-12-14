//
//  ContentView.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var auth = Auth.shared
    
    init() { }
    
    var body: some View {
        
        if Auth.shared.loggedIn {
            if Auth.shared.onboarded {
                Navigator()

            } else {
                OnboardingView()
            }
        } else {
            LoginView()
        }
        
//        NavigationView {
//            if Auth.shared.loggedIn {
//                if Auth.shared.onboarded {
//                    Navigator()
//                    
//                } else {
//                    OnboardingView()
//                }
//            } else {
//                // SignupView()
//                LoginPlaceholder()
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
