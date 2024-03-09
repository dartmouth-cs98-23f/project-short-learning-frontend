//
//  Settings.swift
//  Discite
//
//  Created by Jessie Li on 2/9/24.
//

import SwiftUI
import PhotosUI

struct Settings: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @EnvironmentObject private var user: User
    @ObservedObject var viewModel: AccountViewModel
    @State private var isEditingUserInfo = false
     @State var showPhotoSheet = false
     @State var showPhotoLibrary = false
     @State var selectedPhoto: PhotosPickerItem?
     @State var profileImage = Image(systemName: "person.circle")
    
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
                                 .onTapGesture {
                                     showPhotoSheet.toggle()
                                 }
                                 .confirmationDialog("Select a profile photo", isPresented: $showPhotoSheet) {
                                     Button {
                                         showPhotoLibrary.toggle()
                                     } label: {
                                         Text("Photo Library")
                                     }
                                 }
                                 .photosPicker(isPresented: $showPhotoLibrary, selection: $selectedPhoto, photoLibrary: .shared())
                                 .onChange(of: selectedPhoto) { newValue in
                                     guard let photoItem = selectedPhoto else {
                                         return
                                     }
                                    
                                     Task {
                                         if let photoData = try await photoItem.loadTransferable(type: Data.self),
                                            let uiImage = UIImage(data: photoData) {
                                             await MainActor.run {
                                                 profileImage = Image(uiImage: uiImage)
                                             }
                                         }
                                     }
                                 }
                            
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
            EditUserView(user: user)
        }
        .task {
            if viewModel.error != nil {
                return
            }
        }
        .onChange(of: notificationsEnabled) { newValue in
            UserDefaults.standard.set(newValue, forKey: "notificationsEnabled")
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
