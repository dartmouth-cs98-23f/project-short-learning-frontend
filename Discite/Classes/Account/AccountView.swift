//
//  AccountView.swift
//  Discite
//
//  Created by Jessie Li on 10/22/23.
//

import SwiftUI

struct AccountView: View {
    
    @Binding var showSidebar: Bool

    var body: some View {
        VStack {
            HStack {
                Button {
                    showSidebar.toggle()
                } label: {
                    Image(systemName: "lines.3.horizontal")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                
                Spacer()
            }
                    
            Spacer()
            Text("Account View")
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
}

