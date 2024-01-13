//
//  Signup.swift
//  Discite
//
//  Created by Jessie Li on 1/13/24.
//

import SwiftUI

struct Signup: View {
    @ObservedObject var viewModel: SignupViewModel = SignupViewModel()
    
    var body: some View {
        
        if viewModel.isLoading {
            ProgressView()
            
        } else {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Sign up")
                            .font(Font.H2)
                        
                        if viewModel.error != nil {
                            Text("\(viewModel.error?.localizedDescription ?? "Unknown error")")
                                .foregroundStyle(.red)
                        }
                        
                        VStack(spacing: 24) {
                            PrimaryTextField(label: "Email", text: $viewModel.email) {_ in
                                return viewModel.email.count > 0
                            }
                            
                            CustomSecureTextField(label: "Password", text: $viewModel.password) {_ in
                                return viewModel.password.count > 0
                            }
                        }
                        .padding([.top, .bottom], 48)
                        
                        PrimaryActionButton(
                            action: {
                                Task {
                                    await viewModel.signup()
                                }
                            },
                            label: "Log in",
                            disabled: viewModel.email.count == 0 || viewModel.password.count == 0)
                        
                        HStack {
                            Text("Already have an account?")
                                .font(.body1)
                            
                            TextualNavigationButton(destination: {
                                Login()
                            }, label: "Log in")
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
        }
    }
}

#Preview {
    Signup()
}
