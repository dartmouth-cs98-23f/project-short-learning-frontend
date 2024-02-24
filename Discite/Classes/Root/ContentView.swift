//
//  ContentView.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    // @ObservedObject var auth = Auth.shared

    var body: some View {
        // Navigator()
        GoogleLogin()
    }
        
//        if Auth.shared.loggedIn {
//            AuthView()
//
//        } else {
//            Navigator()
//        }
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
