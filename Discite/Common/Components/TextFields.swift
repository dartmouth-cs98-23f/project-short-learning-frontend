//
//  TextFields.swift
//  Discite
//
//  Created by Jessie Li on 11/13/23.
//

import SwiftUI

struct CustomSecureTextField: View {
    
    let label: String
    @Binding var text: String
    let isValid: (String) -> Bool
    
    init(label: String, text: Binding<String>, isValid: @escaping (String) -> Bool = { _ in return false }) {
        
        self.label = label
        self._text = text
        self.isValid = isValid
        
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            if !text.isEmpty {
                Text(label)
                    .font(Font.small)
                    .foregroundColor(isValid(text) ? Color.secondaryPink : Color.primaryBlueNavy)
            }
            
            VStack {
                
                HStack {
                    SecureField(label, text: $text)
                        .foregroundColor(Color.primaryBlueBlack)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding([.top, .bottom], 4)
                        .font(Font.body1)
                    
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(isValid(text) ? Color.secondaryPink : Color.clear)
                }
                
                Rectangle()
                    .fill(isValid(text) ? Color.secondaryPink : Color.primaryBlueNavy)
                    .frame(height: 2)
                    .edgesIgnoringSafeArea(.horizontal)
            }

        }
        .frame(height: 48)
    }
    
}

struct PrimaryTextField: View {
    
    @Binding var text: String
    let label: String
    let isValid: (String) -> Bool
    
    init(label: String, text: Binding<String>, isValid: @escaping (String) -> Bool = { _ in return false }) {
        
        self.label = label
        self._text = text
        self.isValid = isValid
        
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            if !text.isEmpty {
                Text(label)
                    .font(Font.small)
                    .foregroundColor(isValid(text) ? Color.secondaryPink : Color.primaryBlueNavy)
            }
            
            VStack {
                HStack {
                    TextField(label, text: $text)
                        .foregroundColor(Color.primaryBlueBlack)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding([.top, .bottom], 4)
                        .font(Font.body1)
                    
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(isValid(text) ? Color.secondaryPink : Color.clear)
                }
                
                Rectangle()
                    .fill(isValid(text) ? Color.secondaryPink : Color.primaryBlueNavy)
                    .frame(height: 2)
                    .edgesIgnoringSafeArea(.horizontal)
            }

        }
    }
}

#Preview {
    VStack(spacing: 24) {
        PrimaryTextField(label: "Username", text: .constant("johndoe")) { username in
            return username.count > 0
        }
        
        PrimaryTextField(label: "Username", text: .constant("")) { username in
            return username.count > 0
        }
    }
    .padding(18)
}
