//
//  Signup.swift
//  Discite
//
//  Created by Colton Sankey on 10/25/23.
//

import Foundation
import SwiftUI

struct SignupView: View {
    @ObservedObject var signupModel: SignupViewModel = SignupViewModel()
    @State var orientation = UIDevice.current.orientation
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("Sign Up")
                        .font(.title)
                    HStack {
                        TextField(
                            "Username",
                            text: $signupModel.username
                        )
                        .autocapitalization(.none)
                        .padding()
                        .frame(width: geometry.size == .zero ? geometry.size.width/3 : orientation.isLandscape ? 500 : 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        
                        TextField(
                            "Email",
                            text: $signupModel.email
                        )
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .padding()
                        .frame(width: geometry.size == .zero ? geometry.size.width/3 : orientation.isLandscape ? 500 : 300, height: 50)
                        .background(Color.black.opacity(0.05))
                    }
                    HStack {
                        TextField(
                            "First Name",
                            text: $signupModel.firstname
                        )
                        .autocapitalization(.words)
                        .padding()
                        .frame(width: geometry.size == .zero ? geometry.size.width/3 : orientation.isLandscape ? 500 : 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        
                        TextField(
                            "Last Name",
                            text: $signupModel.lastname
                        )
                        .autocapitalization(.words)
                        .padding()
                        .frame(width: geometry.size == .zero ? geometry.size.width/3 : orientation.isLandscape ? 500 : 300, height: 50)
                        .background(Color.black.opacity(0.05))
                    }
                    HStack {
                        SecureField(
                            "Password",
                            text: $signupModel.password
                        )
                        .autocapitalization(.none)
                        .padding()
                        .frame(width: geometry.size == .zero ? geometry.size.width/3 : orientation.isLandscape ? 500 : 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        
                        SecureField(
                            "Confirm Password",
                            text: $signupModel.confirmPassword
                        )
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .padding()
                        .frame(width: geometry.size == .zero ? geometry.size.width/3 : orientation.isLandscape ? 500 : 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        
                    }
                    Button("Sign up") {
                        signupModel.signup()
                    }
                    .modifier(PrimaryButton())
                    HStack {
                        Text("Already have an account?")
                        NavigationLink(destination: LoginView()) {
                            Text("Log In")
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
