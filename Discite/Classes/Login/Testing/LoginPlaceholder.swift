//
//  LoginPlaceholder.swift
//  Discite
//
//  Created by Jessie Li on 11/13/23.
//

import SwiftUI

struct LoginPlaceholder: View {
    
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    @State var isSignupShowing: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            
            VStack(spacing: 12) {
                Image(.disciteLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                
                Text("Log in")
                    .font(Font.H2)
                    .addGradient(gradient: LinearGradient.pinkOrangeGradient)
            }
            .padding(.bottom, 32)
            
            VStack(spacing: 24) {
                PrimaryTextField(label: "Email", text: $viewModel.usernameOrEmail)
                CustomSecureTextField(label: "Password", text: $viewModel.password)
            }
            .padding(.bottom, 12)
            
            PrimaryActionButton(action: {
                viewModel.login()
            }, label: "Log in", disabled: viewModel.usernameOrEmail.count == 0)
            
            HStack {
                Text("Need an account?")
                TextualButton(action: { isSignupShowing = true }, label: "Sign up")

            }
        }
        .padding(24)
        .sheet(isPresented: $isSignupShowing, content: {
            SignUpPlaceholder(isSignupShowing: $isSignupShowing)
        })
        
    }
}

#Preview {
    LoginPlaceholder()
}
