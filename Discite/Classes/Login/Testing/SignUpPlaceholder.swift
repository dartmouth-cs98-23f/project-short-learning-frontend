//
//  SignUpPlaceholder.swift
//  Discite
//
//  Created by Jessie Li on 11/14/23.
//

import SwiftUI

struct SignUpPlaceholder: View {
    
    @ObservedObject var viewModel: TestSignupViewModel = TestSignupViewModel()
    @Binding var isSignupShowing: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            
            VStack(spacing: 12) {
                Image(.disciteLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                
                Text("Sign up")
                    .font(Font.H2)
                    .addGradient(gradient: LinearGradient.pinkOrangeGradient)
            }
            .padding(.bottom, 32)
            
            VStack(spacing: 24) {
                PrimaryTextField(label: "Username", text: $viewModel.username) {_ in
                    return viewModel.username.count > 0
                }
            
                PrimaryTextField(label: "Email", text: $viewModel.email) {_ in
                    return viewModel.email.count > 0
                }
                
                if viewModel.error != nil {
                    Text("Invalid username or email.")
                        .foregroundColor(.red)
                }
            }
            .padding(.bottom, 12)
            
            PrimaryActionButton(action: {
                viewModel.signup()
            }, label: "Sign up", disabled: viewModel.username.count == 0 || viewModel.email.count == 0)
            
            HStack {
                Text("Already have an account?")
                
                TextualButton(action: { isSignupShowing = false }, label: "Log in")
                
            }
        }
        .padding(24)

    }
    
}

#Preview {
    SignUpPlaceholder(isSignupShowing: .constant(true))
}
