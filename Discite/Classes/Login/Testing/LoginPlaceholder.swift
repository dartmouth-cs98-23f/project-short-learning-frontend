//
//  LoginPlaceholder.swift
//  Discite
//
//  Created by Jessie Li on 11/13/23.
//

import SwiftUI

struct LoginPlaceholder: View {
    
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    
    @State var username: String = ""
    @State var email: String = ""
    
    var body: some View {
        VStack(spacing: 24) {
            Image(.disciteLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100)
                .padding()
            
            PrimaryTextField(label: "Username", text: $username) {_ in
                return username.count > 0
            }
        
            PrimaryTextField(label: "Email", text: $email) {_ in
                return email.count > 0
            }
            
            PrimaryActionButton(action: {
                viewModel.login()
            }, label: "Log in", disabled: username.count == 0 || email.count == 0)
            
            HStack {
                Text("Need an account?")
                TextualButton(action: { }, label: "Sign up")
            }
        }
        .padding(24)
        .padding(.bottom, 54)
    }
}

#Preview {
    LoginPlaceholder()
}
