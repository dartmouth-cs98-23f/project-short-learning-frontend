//
//  Settings.swift
//  Discite
//
//  Created by Jessie Li on 2/9/24.
//

import SwiftUI

struct Settings: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @State private var newName = ""
    @State private var newProfileImage: Image?
    @State private var isShowingImagePicker = false
    @EnvironmentObject private var user: User
    @ObservedObject var viewModel: AccountViewModel
    @State private var isEditingUserInfo = false
    
    var body: some View {
        Form {
            Section(header: Text("Profile")) {
                VStack {
                    HStack {
                        Spacer()
                        Button("Edit") {
                            isEditingUserInfo = true
                        }
                    }
                    
                    HStack {
                        Spacer()
                        HStack(alignment: .top) {
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text(user.fullName)
                                    .font(.body1)
                                
                                Text(user.username)
                                    .font(.body2)
                            }
                            .padding(18)
                            
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .padding(.bottom, 18)
            }
            
            Section(header: Text("Notifications")) {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
            }
            
            Section(header: Text("Appearance")) {
                Toggle("Dark Mode", isOn: $darkModeEnabled)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $isEditingUserInfo) {
            EditUserView(firstName: user.firstName,
                         lastName: user.lastName,
                         username: user.username,
                         isEditingUserInfo: $isEditingUserInfo)
        }
        .task {
            if viewModel.error != nil {
                return
            }
        }
        .onChange(of: notificationsEnabled) { newValue in
            UserDefaults.standard.set(newValue, forKey: "notificationsEnabled")
            // Apply notification settings here
        }
        .onChange(of: darkModeEnabled) { newValue in
            UserDefaults.standard.set(newValue, forKey: "darkModeEnabled")
        }
    }
}

#Preview {
    let viewModel = AccountViewModel()
    
    return Settings(viewModel: viewModel)
        .environmentObject(User())
}
