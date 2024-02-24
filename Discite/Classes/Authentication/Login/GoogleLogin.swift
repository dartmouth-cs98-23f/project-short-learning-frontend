//
//  GoogleLogin.swift
//  Discite
//
//  Created by Jessie Li on 2/23/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct GoogleLogin: View {
    @EnvironmentObject var vm: AuthViewModel
    
    let customGoogleViewModel = GoogleSignInButtonViewModel(style: .icon)
    var body: some View {
        
        VStack {
            if vm.isLoggedIn {
                Text("Logged in!")
            } else {
                Text("Signed out.")
            }
            
            GoogleSignInButton(viewModel: customGoogleViewModel, action: vm.googleSignIn)
            
        }
    }

}

#Preview {
    GoogleLogin()
        .environmentObject(AuthViewModel())
}
