//
//  DisciteApp.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//
//  Google sign-in:
//      https://developers.google.com/identity/sign-in/ios/sign-in

import SwiftUI
import Firebase

@main
struct DisciteApp: App {
        
    init() {
        NetworkMonitor.shared.startMonitoring()
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
