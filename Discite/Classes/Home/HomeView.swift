//
//  HomeView.swift
//  Discite
//
//  Created by Jessie Li on 10/18/23.
//
//  Source:
//      https://medium.com/mop-developers/build-your-first-swiftui-app-part-5-handling-authorization-95f49cdb0b29

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()

    var body: some View {
        VStack {
            Spacer()
            
            Text("Home.Title")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Spacer()
            
            Button(
                action: viewModel.logout,
                label: {
                    Text("Home.LogoutButton.Title")
                        .modifier(PrimaryButton(color: Color.red))
                }
            )
        }
        .padding(30)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
