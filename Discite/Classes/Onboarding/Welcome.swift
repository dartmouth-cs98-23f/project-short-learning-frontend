//
//  LogoSplash.swift
//  Discite
//
//  Created by Jessie Li on 12/8/23.
//

import SwiftUI

struct Welcome: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image("Logo.Dark")
                .padding(12)
            
            Text("Logo.Subtitle")
                .font(.subtitle1)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            PrimaryActionButtonPurple(action: { }, label: "Begin")
        }
        .padding([.leading, .trailing], 30)
        .padding(.bottom, 85)
        .background(LinearGradient.blueBlackLinear)
        .foregroundColor(.secondaryPeachLight)
    }
}

#Preview {
    Welcome()
}
