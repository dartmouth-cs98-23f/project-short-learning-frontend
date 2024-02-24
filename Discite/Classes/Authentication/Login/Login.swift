//
//  Login.swift
//  Discite
//
//  Created by Jessie Li on 1/13/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct Login: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        if viewModel.status == .loading {
            ProgressView("Logging in...")
            
        } else {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Log in")
                            .font(Font.H2)
                        
                        // error message, if any
                        if viewModel.error != nil {
                            Text("\(viewModel.error?.localizedDescription ?? "Unknown error")")
                                .foregroundStyle(.red)
                        }
                        
                        // text fields
                        VStack(spacing: 24) {
                            PrimaryTextField(label: "Email", text: $viewModel.usernameOrEmail)
                            CustomSecureTextField(label: "Password", text: $viewModel.password)
                        }
                        .padding([.top, .bottom], 48)
                        
                        loginButton()
                        
                        signUpFooter()
                        
                        // logo
                        Image(.logoSmall)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 48, alignment: .trailing)
                        
                    }
                    .padding([.top, .bottom], 48)
                    .frame(minHeight: geometry.size.height)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    @ViewBuilder
    func loginButton() -> some View {
        PrimaryActionButton(
            action: {
                Task {
                    await viewModel.login()
                }
            },
            label: "Log in",
            disabled: viewModel.usernameOrEmail.count == 0)
    }
    
    @ViewBuilder
    func signUpFooter() -> some View {
        HStack {
            Text("Need an account?")
                .font(.body1)
            
            TextualNavigationButton(destination: {
                Signup()
            }, label: "Sign up")
        }
        .padding(.top, 12)
    }
    
}

#Preview {
    Login()
        .environmentObject(AuthViewModel())
}
