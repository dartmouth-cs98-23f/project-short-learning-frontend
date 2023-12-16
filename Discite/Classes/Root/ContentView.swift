//
//  ContentView.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @ObservedObject var auth = Auth.shared

    var body: some View {
        Navigator()
    }
        
//        if Auth.shared.loggedIn {
//            if Auth.shared.onboarded {
//                
//                Navigator()
//                    .environmentObject(context)
//                    .task {
//                        do {
//                            async let sequence = VideoService.loadSequence()
//                            async let topics = ExploreService.loadTopics()
//                            
//                            context.sequence = try await sequence
//                            context.topics = await topics
//                        } catch {
//                            print("Failed to load context.")
//                        }
//                    }
//
//            } else {
//                OnboardingView()
//            }
//            
//        } else {
//            LoginView()
//        }
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
