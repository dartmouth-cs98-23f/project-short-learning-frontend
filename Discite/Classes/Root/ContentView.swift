//
//  ContentView.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            switch authViewModel.status {
            case .loading:
                ProgressView()
                    .containerRelativeFrame([.horizontal, .vertical])
            case .error:
                Text("Error.")
            case .loggedIn:
                Navigator()
            case .onboarding:
                OnboardingPage()
            case .loggedOut:
                GoogleLogin()
                     .navigationBarTitle("Sign in", displayMode: .inline)
                     .navigationBarHidden(true)
            }
        }
        .animation(.smooth, value: authViewModel.status)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
