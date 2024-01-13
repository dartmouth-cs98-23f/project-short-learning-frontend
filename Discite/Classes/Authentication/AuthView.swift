//
//  Welcome.swift
//  Discite
//
//  Created by Jessie Li on 1/13/24.
//

import SwiftUI

struct AuthView: View {
    
    var body: some View {
        NavigationStack {
            NavigationLink { Login() } label: {
                Text("Log in")
            }
            
            NavigationLink { SignupView() } label: {
                Text("Sign up")
            }

        }
    }

}

#Preview {
    AuthView()
}
