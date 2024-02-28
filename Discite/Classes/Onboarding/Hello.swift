//
//  Hello.swift
//  Discite
//
//  Created by Jessie Li on 2/27/24.
//

import SwiftUI

struct Hello: View {
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                VStack(alignment: .leading) {
                    Text("Hello,")
                        .font(.H1)
                    
                    Text("\(User.shared.firstName).")
                        .font(.extraBig)
                        .foregroundStyle(Color.primaryPurpleLight)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Help us personalize your learning experience.")
                    .font(.subtitle1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 18)
                
                NavigationLink {
                    OnboardingPage()
                    
                } label: {
                    Text("Get started")
                        .font(.button)
                        .padding(12)
                        .foregroundStyle(Color.white)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.primaryBlueBlack)
                        }
                }
            }
            .padding(.horizontal, 18)
        }
    }
}

#Preview {
    Hello()
}
