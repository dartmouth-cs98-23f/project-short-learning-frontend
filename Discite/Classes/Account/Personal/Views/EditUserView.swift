//
//  EditUserView.swift
//  Discite
//
//  Created by Bansharee Ireen on 3/7/24.
//

import SwiftUI

struct EditUserView: View {
    @ObservedObject var user: User
    @StateObject var viewModel = EditUserViewModel()

    var body: some View {
        if case .loading = user.loadingState {
            // Must ensure user is loaded before configuring the edit view
            ProgressView()
                .containerRelativeFrame([.vertical, .horizontal])
            
        } else {
            Form {
                TextField("First Name", text: $viewModel.firstName)
                    .autocapitalization(.words)
                    .autocorrectionDisabled()
                
                TextField("Last Name", text: $viewModel.lastName)
                    .autocapitalization(.words)
                    .autocorrectionDisabled()
                
                TextField("Username", text: $viewModel.username)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .autocorrectionDisabled()
                
                TextField("Profile Picture URL", text: $viewModel.profilePicture)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .autocorrectionDisabled()
                
                Button("Save Changes") {
                    viewModel.updateUser(user: user)
                }
                .disabled(!enableSave())
            }
            .navigationTitle("Edit Profile")
            .onAppear {
                viewModel.configureWith(user: user)
            }
            .toastView(toast: $viewModel.toast)
        }
    }
    
    private func enableSave() -> Bool {
        return viewModel.firstName != user.firstName
            || viewModel.lastName != user.lastName
            || viewModel.username != user.username
            || viewModel.profilePicture != user.profilePicture
    }
}

#Preview {
    EditUserView(user: User())
}
