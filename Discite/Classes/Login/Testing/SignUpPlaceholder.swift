//
//  SignUpPlaceholder.swift
//  Discite
//
//  Created by Jessie Li on 11/14/23.
//

import SwiftUI

struct SignUpPlaceholder: View {
    
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    
    @State var username: String = ""
    @State var email: String = ""
    
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
                PrimaryTextField(label: "Username", text: $username) {_ in
                    return username.count > 0
                }
            
                PrimaryTextField(label: "Email", text: $email) {_ in
                    return email.count > 0
                }
            }
            .padding(.bottom, 12)
            
            PrimaryActionButton(action: {
                viewModel.login()
            }, label: "Sign up", disabled: username.count == 0 || email.count == 0)
            
            HStack {
                Text("Already have an account?")
                
                NavigationLink {
                    SignUpPlaceholder()
                } label: {
                    TextualButton(action: { }, label: "Log in")
                }
                
            }
        }
        .padding(24)

    }
    
}

#Preview {
    SignUpPlaceholder()
}
