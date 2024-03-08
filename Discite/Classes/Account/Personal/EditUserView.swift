//
//  EditUserView.swift
//  Discite
//
//  Created by Bansharee Ireen on 3/7/24.
//

import SwiftUI

struct EditUserView: View {
    @State var firstName: String
    @State var lastName: String
    @State var username: String
//    @State private var profilePicture: String?
    @ObservedObject var viewModel = AccountViewModel()
    @Binding var isEditingUserInfo: Bool
    @State private var isFormSubmitted = false

    var body: some View {
        NavigationView {
            Form {
                TextField("First Name", text: $firstName)
                    .autocapitalization(.words)
                    .autocorrectionDisabled()
                
                TextField("Last Name", text: $lastName)
                    .autocapitalization(.words)
                    .autocorrectionDisabled()
                
                TextField("Username", text: $username)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .autocorrectionDisabled()
                
                Button("Save Changes") {
                    isFormSubmitted = true
                    isEditingUserInfo = false
                }
            }
            .onChange(of: isFormSubmitted) { newValue in
                guard newValue else { return }
                Task {
                    do {
                        try await viewModel.updateUser(firstName: firstName, lastName: lastName, username: username, profilePicture: nil)
                    } catch {
                        // handle error
                        print("Error updating user: \(error)")
                    }
                }
                // Reset the form submitted flag
                isFormSubmitted = false
            }
            .navigationTitle("Edit Profile")
        }
        .task {
            if viewModel.error != nil {
                return
            }
        }
    }
}
