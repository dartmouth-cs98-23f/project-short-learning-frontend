//
//  AccountMenu.swift
//  Discite
//
//  Created by Jessie Li on 2/9/24.
//

import SwiftUI

struct AccountMenu: View {
    @EnvironmentObject var user: User
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: AccountViewModel

    var body: some View {
        VStack(spacing: 14) {
            NavigationLink {
                Settings()
            } label: {
                textualMenuButton(label: "Settings")
            }

            logoutButton()

        }
        .padding([.leading, .trailing], 18)
    }

    @ViewBuilder
    func textualMenuButton(label: String) -> some View {
        Text(label)
            .font(.H5)
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    func logoutButton() -> some View {
        Button(action: {
            do {
                try user.clear()
            } catch {
                print("Unable to log out \(error)")
            }

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
        .environmentObject(User())
}
