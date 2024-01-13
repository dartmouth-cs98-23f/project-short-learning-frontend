//
//  Welcome.swift
//  Discite
//
//  Created by Jessie Li on 1/13/24.
//

import SwiftUI

struct AuthView: View {
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 12) {
                Image("Logo")
                
                Text("Logo.Subtitle")
                    .font(.subtitle1)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 168)
            
            Spacer()
            
            NavigationStack {
                PrimaryNavigationButton(destination: {
                    Login()
                }, label: "Log in")
                
                SecondaryNavigationButton(destination: {
                    Signup()
                }, label: "Sign up")
            }
            .padding(.bottom, 84)

        }
        .padding([.leading, .trailing], 24)

    }

}

#Preview {
    AuthView()
}
