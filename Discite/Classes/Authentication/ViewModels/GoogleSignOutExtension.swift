//
//  GoogleSignOutExtension.swift
//  Discite
//
//  Created by Jessie Li on 2/28/24.
//

import SwiftUI
import Foundation
import GoogleSignIn

@MainActor
func googleSignOut(user: User) {
    do {
        GIDSignIn.sharedInstance.signOut()
        try user.clear()
        
        withAnimation(.spring) {
            user.state = .signedOut
        }
        
    } catch {
        print("Error signing out.")
    }
}
