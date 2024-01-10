//
//  SearchBar.swift
//  Discite
//
//  Created by Jessie Li on 12/13/23.
//

import SwiftUI

struct SearchBar: View {
    
    var placeholder: String?
    @Binding var text: String
    @State private var isEditing = false
 
    var body: some View {
        TextField(placeholder ?? "Search...", text: $text)
            .font(Font.body1)
            .padding(8)
            .padding(.horizontal, 24)
            .background(Color.primaryBlueLightest)
            .cornerRadius(10)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                    if isEditing {
                        Button {
                            self.text = ""
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.grayDark)
                        }
                    }
                }
                    .padding([.leading, .trailing], 8)
                
            )
            .onTapGesture {
                self.isEditing = true
            }
            .animation(.smooth(duration: 0.5), value: isEditing)
    }
}

#Preview {
    SearchBar(text: .constant(""))
        .foregroundColor(.primaryBlueNavy)
        .padding(.horizontal, 12)
}
