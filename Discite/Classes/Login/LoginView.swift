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

    var body: some View {
        VStack {
            VStack {
                TextField(
                    "Login.UsernameOrEmailField.Title",
                    text: $viewModel.usernameOrEmail
                )
                .autocapitalization(.none)
                .padding()
                .frame(width: 500, height: 50)
                .background(Color.black.opacity(0.05))

                SecureField(
                    "Login.PasswordField.Title",
                     text: $viewModel.password
                )
                .padding()
                .frame(width: 500, height: 50)
                .background(Color.black.opacity(0.05))
            }

            Button("Login.Button.Text") {
                viewModel.login()
            }
            .frame(width: 500, height: 50)
            .foregroundColor(Color.white)
            .background(Color.blue)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
