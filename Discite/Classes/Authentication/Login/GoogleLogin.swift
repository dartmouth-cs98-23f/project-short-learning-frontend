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
    let viewModel = AuthViewModel.shared
    let customGoogleViewModel = GoogleSignInButtonViewModel(style: .wide)
    
    var body: some View {
    
        VStack(spacing: 32) {
            // logo and subtitle
            VStack(alignment: .leading, spacing: 18) {
                Image("Logo")
                Text("Logo.Subtitle")
                    .font(.subtitle1)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // buttons
            VStack(spacing: 24) {
                // sign in with google button
                GoogleSignInButton(
                    viewModel: customGoogleViewModel,
                    action: viewModel.googleSignIn)
                
                // preview first button
                Button {
                    print("setting preview mode")
                    viewModel.setPreviewMode()
                    print("viewModel.status: \(viewModel.status)")
                    
                } label: {
                    HStack(alignment: .center, spacing: 4) {
                        Text("Preview first")
                        Image(systemName: "arrow.right")
                    }
                }
                .font(.body2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.primaryPurple)
                
                // preview first button
//                NavigationLink {
//                    OnboardingPage()
//                    
//                } label: {
//                    HStack(alignment: .center, spacing: 4) {
//                        Text("Preview first")
//                        Image(systemName: "arrow.right")
//                    }
//                }
//                .onTapGesture {
//                    viewModel.setPreviewMode()
//                }
//                .font(.body2)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .foregroundStyle(Color.primaryPurple)

            }
        }
        .padding(.horizontal, 18)
            
    }
}

#Preview {
    GoogleLogin()
        .environmentObject(AuthViewModel())
}
