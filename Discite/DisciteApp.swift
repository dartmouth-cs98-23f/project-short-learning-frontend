//
//  DisciteApp.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//

import SwiftUI

@main
struct DisciteApp: App {
        
    init() {
        NetworkMonitor.shared.startMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
