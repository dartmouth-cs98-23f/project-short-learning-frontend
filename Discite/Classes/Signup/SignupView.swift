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
    let fileManager = FileManager.default
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Image(.disciteLogo)
                            .resizable()
                            .frame(width: 250, height: 130)
                            .padding()
                        Spacer()
                    }
                    if signupModel.internalError != "" {
                        Text(signupModel.internalError)
                            .foregroundStyle(.red)
                    }
                    
                    TextField(
                        "Username",
                        text: $signupModel.username
                    )
                    .autocapitalization(.none)
                    .padding()
                    .frame(width: geometry.size.width-20, height: 50)
                    .background(Color.black.opacity(0.05))
                    
                    TextField(
                        "Email",
                        text: $signupModel.email
                    )
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding()
                    .frame(width: geometry.size.width-20, height: 50)
                    .background(Color.black.opacity(0.05))
                    
                    TextField(
                        "First Name",
                        text: $signupModel.firstname
                    )
                    .autocapitalization(.words)
                    .padding()
                    .frame(width: geometry.size.width-20, height: 50)
                    .background(Color.black.opacity(0.05))
                    
                    TextField(
                        "Last Name",
                        text: $signupModel.lastname
                    )
                    .autocapitalization(.words)
                    .padding()
                    .frame(width: geometry.size.width-20, height: 50)
                    .background(Color.black.opacity(0.05))
                    
                    HStack {
                        DatePicker(selection: $signupModel.date, displayedComponents: .date) {
                            Text("Select Birthdate")
                                .opacity(0.25)
                        }
                        .padding()
                        .frame(width: geometry.size.width-20, height: 50)
                        .background(Color.black.opacity(0.05))
                    }
                    
                    SecureField(
                        "Password",
                        text: $signupModel.password
                    )
                    .autocapitalization(.none)
                    .padding()
                    .frame(width: geometry.size.width-20, height: 50)
                    .background(Color.black.opacity(0.05))
                    
                    SecureField(
                        "Confirm Password",
                        text: $signupModel.confirmPassword
                    )
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding()
                    .frame(width: geometry.size.width-20, height: 50)
                    .background(Color.black.opacity(0.05))
                    
                    Button("Sign up") {
                        signupModel.signup()
                    }
                    .modifier(PrimaryButton())
                    .frame(width: geometry.size.width - 20, height: 50)
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
            }
        }
    }
}

 struct SignupView_Previews: PreviewProvider {
     static var previews: some View {
         SignupView()
     }
 }
