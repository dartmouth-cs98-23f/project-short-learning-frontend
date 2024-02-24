//
//  DisciteApp.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//
//  Google sign-in:
//      https://developers.google.com/identity/sign-in/ios/sign-in

import SwiftUI
import GoogleSignIn

@main
struct DisciteApp: App {
    
    @StateObject var userAuth: AuthViewModel =  AuthViewModel()
        
    init() {
        NetworkMonitor.shared.startMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userAuth)
        }
    }
}
