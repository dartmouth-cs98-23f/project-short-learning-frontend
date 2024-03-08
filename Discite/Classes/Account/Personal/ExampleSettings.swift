//
//  ExampleSettings.swift
//  Discite
//
//  Created by Bansharee Ireen on 3/7/24.
//

import SwiftUI

struct ExampleView: View {
    @StateObject var viewModel = AccountViewModel()
    @State private var isEditing = false
    @State private var newName = ""
    @State private var newLastName = ""
    @State private var newUsername = ""

    var body: some View {
        VStack {
            if isEditing {
                EditUserInfoView(newName: $newName, newLastName: $newLastName, newUsername: $newUsername, isEditing: $isEditing, viewModel: viewModel)
            } else {
                UserInfoView(name: newName, lastName: newLastName, username: newUsername, isEditing: $isEditing)
            }
        }
        .padding()
    }
}

struct UserInfoView: View {
    let name: String
    let lastName: String
    let username: String
    @Binding var isEditing: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text("First Name: \(name)")
            Text("Last Name: \(lastName)")
            Text("Username: \(username)")
            Spacer()
            Button("Edit") {
                isEditing.toggle()
            }
        }
    }
}

struct EditUserInfoView: View {
    @Binding var newName: String
    @Binding var newLastName: String
    @Binding var newUsername: String
    @Binding var isEditing: Bool
    let viewModel: AccountViewModel

    var body: some View {
        VStack {
            TextField("First Name", text: $newName)
            TextField("Last Name", text: $newLastName)
            TextField("Username", text: $newUsername)
            Spacer()
            Button("Save") {
                // Call ViewModel to update user
                
                isEditing.toggle()
            }
        }
        .padding()
    }
}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}
