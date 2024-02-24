//
//  AccountMenu.swift
//  Discite
//
//  Created by Jessie Li on 2/9/24.
//

import SwiftUI

struct AccountMenu: View {
    @ObservedObject var viewModel: AccountViewModel
    let authViewModel: AuthViewModel = AuthViewModel.shared

    var body: some View {
        VStack(spacing: 14) {
            NavigationLink {
                SavedPage()
            } label: {
                textualMenuButton(label: "Saved")
            }
            
            NavigationLink {
                FriendsPage()
            } label: {
                textualMenuButton(label: "Friends")
            }
            
            NavigationLink {
                Settings()
            } label: {
                textualMenuButton(label: "Settings")
            }
            
            logoutButton()
            
        }
        .padding([.leading, .trailing], 18)
    }
    
    func textualMenuButton(label: String) -> some View {
        Text(label)
            .font(.H5)
            .foregroundColor(Color.primaryBlueBlack)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func logoutButton() -> some View {
        Button(action: {
            // viewModel.logout()
            authViewModel.googleSignOut()
            
        }, label: {
            Text("Log out")
                .font(.button)
                .foregroundColor(Color.red)
                .frame(maxWidth: .infinity, alignment: .leading)
        })
    }
}

#Preview {
    let viewModel = AccountViewModel()
    
    return AccountMenu(viewModel: viewModel)
}
