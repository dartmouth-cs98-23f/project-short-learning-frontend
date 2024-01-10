//
//  Loading.swift
//  Discite
//
//  Created by Jessie Li on 11/14/23.
//

import SwiftUI

struct Loading: View {
    
    @State private var isLoading = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(Color.pink, lineWidth: 5)
            .frame(width: 80, height: 80)
            .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isLoading)
            .onAppear {
                self.isLoading = true
            }
    }
}

#Preview {
    Loading()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBlueBlack)
}
