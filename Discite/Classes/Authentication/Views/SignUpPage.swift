//
//  SignUpPage.swift
//  Discite
//
//  Created by Jessie Li on 2/28/24.
//

import SwiftUI

struct SignUpPage: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var user: User
    @StateObject var viewModel: SignupViewModel = SignupViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack {
                textField(label: "Email", text: $viewModel.username) { text in
                    return !text.isEmpty
                }
                
                textField(label: "First name", text: $viewModel.firstname) { text in
                    return !text.isEmpty
                }
                          
                textField(label: "Last name", text: $viewModel.lastname) { text in
                    return !text.isEmpty
                }
                          
                textField(label: "Username", text: $viewModel.username) { text in
                    return !text.isEmpty
                }
                
                secureTextField(label: "Password", text: $viewModel.password) { text in
                    return text.count >= 8
                }
                
                secureTextField(label: "Confirm password", text: $viewModel.confirmPassword) { text in
                    return text == viewModel.password
                }
            }
            
            signUpButton()
            
            loginFooter()
        }
        .padding(.horizontal, 18)
    }
    
    @ViewBuilder
    func loginFooter() -> some View {
        HStack {
            Text("Already have an account?")
            
            Button {
                dismiss()
                
            } label: {
                Text("Log in")
            }
        }
        .font(.body2)
    }
    
    @ViewBuilder
    func textField(label: String, text: Binding<String>, isValid: (String) -> Bool) -> some View {
        VStack(alignment: .leading) {
            
            Text(!text.wrappedValue.isEmpty ? label : "")
                .frame(minHeight: 18)
                .font(Font.small)
                .foregroundStyle(isValid(text.wrappedValue) ? Color.primaryPurple : .primaryBlueBlack)
            
            TextField(label, text: text)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.vertical, 2)
                .font(Font.body1)

            Divider()
                .overlay(isValid(text.wrappedValue) ? Color.primaryPurple : .clear)
            
        }
        .animation(.easeIn, value: text.wrappedValue.isEmpty)
        .frame(minHeight: 56)
        .foregroundColor(Color.primaryBlueBlack)
    }
    
    @ViewBuilder
    func secureTextField(label: String, text: Binding<String>, isValid: (String) -> Bool) -> some View {
        VStack(alignment: .leading) {
            Text(!text.wrappedValue.isEmpty ? label : "")
                .frame(minHeight: 18)
                .font(Font.small)
                .foregroundStyle(isValid(text.wrappedValue) ? Color.primaryPurple : .primaryBlueBlack)
            
            SecureField(label, text: text)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.vertical, 2)
                .font(Font.body1)
            
            Divider()
                .overlay(isValid(text.wrappedValue) ? Color.primaryPurple : .clear)
        }
        .animation(.easeIn, value: text.wrappedValue.isEmpty)
        .frame(minHeight: 56)
        .foregroundColor(Color.primaryBlueBlack)
    }
    
    @ViewBuilder
    func signUpButton() -> some View {
        let disabled = 
        viewModel.email.count == 0 
        || viewModel.password.count < 8
        || (viewModel.password != viewModel.confirmPassword)
        
        Button {
            Task {
                await viewModel.signup(user: user)
            }
            
        } label: {
            Text("Sign up")
                .frame(maxWidth: .infinity)
                .padding(14)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(disabled ? Color.grayNeutral : Color.primaryBlueBlack)
                }
            
        }
        .font(.button)
        .foregroundStyle(Color.white)
        .disabled(disabled)
    }
}

#Preview {
    SignUpPage()
        .environmentObject(User())
}
