//
//  LoginView.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
// 
//  Source:
//      https://medium.com/mop-developers/build-your-first-swiftui-app-part-3-create-the-login-screen-334d90ef1763

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    @State var orientation = UIDevice.current.orientation

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                HStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            
                            Image(.disciteLogo)
                                .resizable()
                                .frame(width: 250, height: 130, alignment: .center)
                                .padding()
                            Spacer()
                        }
                        TextField(
                            "Auth.UsernameOrEmailField.Title",
                            text: $viewModel.usernameOrEmail
                        )
                        .autocapitalization(.none)
                        .padding()
                        .frame(width: geometry.size.width - 20, height: 50)
                        .background(Color.black.opacity(0.05))
                        
                        SecureField(
                            "Auth.PasswordField.Title",
                            text: $viewModel.password
                        )
                        .padding()
                        .frame(width: geometry.size.width-20, height: 50)
                        .background(Color.black.opacity(0.05))
                        
                        if viewModel.error != nil {
                            Text("\(viewModel.error?.localizedDescription ?? "Unknown error")")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        
                        Button("Login.Button.Text") {
                            viewModel.login()
                        }
                        .modifier(PrimaryButton())
                        .frame(width: geometry.size.width-20, height: 50)
                        
                        HStack {
                            Spacer()
                            Text("Don't have an account?")
                            NavigationLink(destination: SignupView()) {
                                Text("Sign Up")
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
