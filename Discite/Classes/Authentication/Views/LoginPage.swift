//
//  GoogleLogin.swift
//  Discite
//
//  Created by Jessie Li on 2/23/24.
//

import SwiftUI
// import GoogleSignIn
// import GoogleSignInSwift
// import AuthenticationServices

struct LoginPage: View {
    @EnvironmentObject var user: User
    @ObservedObject var viewModel = LoginViewModel()

    var body: some View {

        VStack(spacing: 32) {
            // logo and subtitle
            VStack(alignment: .leading, spacing: 18) {
                Image("Logo")
                Text("Logo.Subtitle")
                    .font(.subtitle1)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if viewModel.error != nil {
                    Text("Sorry, we couldn't log you in.")
                        .foregroundStyle(Color.red)
                }
            }
            .animation(.smooth, value: viewModel.error == nil)

            // regular sign in
            textField(label: "Email", text: $viewModel.usernameOrEmail)
            secureTextField(label: "Password", text: $viewModel.password)

            signInButton()

            // buttons
            HStack(alignment: .center, spacing: 24) {
                signUpFooter()

                Spacer()

                // preview first button
                // previewButton()

            }
        }
        .padding(.horizontal, 18)
        .navigationBarBackButtonHidden(true)

    }

    @ViewBuilder
    func signUpFooter() -> some View {
        HStack {
            Text("Need an account?")

            NavigationLink {
                SignUpPage()

            } label: {
                Text("Sign up")
            }
        }
        .font(.body2)
    }

    @ViewBuilder
    func textField(label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {

            Text(!text.wrappedValue.isEmpty ? label : "")
                .frame(minHeight: 18)
                .font(Font.small)

            TextField(label, text: text)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.vertical, 2)
                .font(Font.body1)

            Divider()
                .foregroundStyle(Color.primaryBlueBlack)
        }
        .animation(.easeIn, value: text.wrappedValue.isEmpty)
        .frame(minHeight: 56)
        .foregroundColor(Color.primaryBlueBlack)
    }

    @ViewBuilder
    func secureTextField(label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(!text.wrappedValue.isEmpty ? label : "")
                .frame(minHeight: 18)
                .font(Font.small)

            SecureField(label, text: text)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.vertical, 2)
                .font(Font.body1)

            Divider()
                .foregroundStyle(Color.primaryBlueBlack)
        }
        .animation(.easeIn, value: text.wrappedValue.isEmpty)
        .frame(minHeight: 56)
        .foregroundColor(Color.primaryBlueBlack)
    }

    @ViewBuilder
    func signInButton() -> some View {
        let disabled = viewModel.usernameOrEmail.count == 0

        Button {
            Task {
                await viewModel.signIn(user: user)
            }

        } label: {
            Text("Log in")
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

//    @ViewBuilder
//    func googleSignInButton() -> some View {
//        Button {
//            viewModel.googleSignIn(user: user)
//            
//        } label: {
//            ZStack {
//                Circle()
//                    .foregroundColor(.white)
//                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
//                
//                Image("google")
//                    .resizable()
//                    .scaledToFit()
//                    .padding(8)
//                    .mask(
//                        Circle()
//                    )
//            }
//            .frame(width: 50, height: 50)
//        }
//    }

//    @ViewBuilder
//    func appleSignInButton() -> some View {
//        SignInWithAppleButton(.continue) { request in
//            request.requestedScopes = [.email, .fullName]
//        } onCompletion: { result in
//            switch result {
//            case .success(let auth):
//                switch auth.credential {
//                case let credential as ASAuthorizationAppleIDCredential:
//                    // need to cache these
//                    let email = credential.email
//                    let firstName = credential.fullName?.givenName
//                    let lastName = credential.fullName?.familyName
//                    
//                    // only item that we get back after authenticating / leave app
//                    let userId = credential.user
//                    
//                default:
//                    break
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//        .signInWithAppleButtonStyle(.whiteOutline)
//        .frame(height: 48)
//    }

    @ViewBuilder
    func previewButton() -> some View {
        Button {
            user.configure()

        } label: {
            HStack(alignment: .center, spacing: 4) {
                Text("Preview first")
                Image(systemName: "arrow.right")
            }
        }
        .font(.body2)
        .foregroundStyle(Color.primaryPurple)
    }
}

#Preview {
    LoginPage()
        .environmentObject(User())
}
