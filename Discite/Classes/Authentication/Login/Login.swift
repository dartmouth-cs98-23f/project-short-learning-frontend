//
//  Login.swift
//  Discite
//
//  Created by Jessie Li on 1/13/24.
//

import SwiftUI

struct Login: View {
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        
        if (viewModel.isLoading) {
            ProgressView("Logging in...")
            
        } else {
            ScrollView() {
                VStack() {
                    Image(.logo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 100)
                    
                    Text("Log in")
                        .font(Font.H2)
                        .addGradient(gradient: LinearGradient.pinkOrangeGradient)
                }
                .padding(.bottom, 32)
                
                if viewModel.error != nil {
                    Text("\(viewModel.error?.localizedDescription ?? "Unknown error")")
                        .foregroundStyle(.red)
                }
                
                VStack() {
                    PrimaryTextField(label: "Email", text: $viewModel.usernameOrEmail)
                    CustomSecureTextField(label: "Password", text: $viewModel.password)
                }
                .padding(.bottom, 12)
                
                PrimaryActionButton(
                    action: {
                        Task {
                            await viewModel.login()
                        }
                    },
                    label: "Log in",
                    disabled: viewModel.usernameOrEmail.count == 0)
                
                HStack {
                    Text("Need an account?")
                    NavigationLink(destination: SignupView()) {
                        Text("Sign up")
                    }
                    // TextualButton(action: { }, label: "Sign up")
                    
                }
            }
        }
    }
}

#Preview {
    Login()
}
