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
    @ObservedObject var auth = Auth.shared
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        Image(.disciteLogo)
                            .resizable()
                            .frame(width: 250, height: 130)
                            .padding()
                        Spacer()
                    }
                    if viewModel.error != nil {
                        Text("Invalid Email or Password")
                            .foregroundStyle(.red)
                            .bold()
                            .frame(alignment: .leading)
                    }
                    TextField(
                        "Email",
                        text: $viewModel.usernameOrEmail
                    )
                    .autocapitalization(.none)
                    .padding()
                    .frame(width: geometry.size.width - 20, height: 50)
                    .background(Color.black.opacity(0.05))
                    
                    SecureField(
                        "Password",
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
                    
                    PrimaryActionButton(action: {
                        viewModel.login()
                        
                    }, label: "Login.Button.Text", disabled: false)
                    .frame(width: geometry.size.width-20, height: 50)
                    
                    HStack {
                        Text("Don't have an account?")
                        NavigationLink(destination: SignupView()) {
                            Text("Sign Up")
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                        }
                    }
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
