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
        
        if viewModel.isLoading {
            ProgressView("Logging in...")
            
        } else {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Log in")
                            .font(Font.H2)
                        
                        if viewModel.error != nil {
                            Text("\(viewModel.error?.localizedDescription ?? "Unknown error")")
                                .foregroundStyle(.red)
                        }
                        
                        VStack(spacing: 24) {
                            PrimaryTextField(label: "Email", text: $viewModel.usernameOrEmail)
                            CustomSecureTextField(label: "Password", text: $viewModel.password)
                        }
                        .padding([.top, .bottom], 48)
                        
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
                                .font(.body1)
                            
                            TextualNavigationButton(destination: {
                                Signup()
                            }, label: "Sign up")
                        }
                        .padding(.top, 12)
                        
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
}

#Preview {
    Login()
}
