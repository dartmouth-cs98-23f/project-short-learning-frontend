//
//  EditUserView.swift
//  Discite
//
//  Created by Bansharee Ireen on 3/7/24.
//

import SwiftUI

struct EditUserView: View {
    @EnvironmentObject private var user: User
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var username: String = ""
//    @State private var profilePicture: String?
    @ObservedObject var viewModel: AccountViewModel
    @Binding var isEditingUserInfo: Bool

    var body: some View {
        NavigationView {
            Form {
                TextField("First Name", text: $firstName)
                    .autocapitalization(.words)
                
                TextField("Last Name", text: $lastName)
                    .autocapitalization(.words)
                
                TextField("Username", text: $username)
                    .autocapitalization(.words)
            }
            .onSubmit {
                Task {
                    do {
                        try await viewModel.updateUser(firstName: firstName, lastName: lastName, profilePicture: user.profilePicture)
                    } catch {
                        // Handle error
                        print("Error updating user: \(error)")
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(trailing: Button("Done") {
                isEditingUserInfo = false
            })
        }
        .task {
            if viewModel.error != nil {
                return
            }
        }
    }
}
