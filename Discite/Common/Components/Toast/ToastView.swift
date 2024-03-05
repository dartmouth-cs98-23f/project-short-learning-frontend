//
//  ToastView.swift
//  Discite
//
//  Created by Jessie Li on 2/16/24.
//
//  https://ondrej-kvasnovsky.medium.com/how-to-build-a-simple-toast-message-view-in-swiftui-b2e982340bd
// 

import SwiftUI

struct ToastView: View {
  
  var style: ToastStyle
  var message: String
  var width = CGFloat.infinity
  var onCancelTapped: (() -> Void)
  
  var body: some View {
      HStack(alignment: .center, spacing: 12) {
        
          // icon
          Image(systemName: style.iconFileName)
              .foregroundStyle(style.themeColor)
      
          // message
          Text(message)
              .font(Font.body1)
              .foregroundStyle(Color.white)
      
          Spacer(minLength: 10)
        
          // close button
          Button {
              onCancelTapped()
          } label: {
              Image(systemName: "xmark")
                  .foregroundStyle(Color.white)
          }
        
      }
      .frame(maxWidth: .infinity, minHeight: 48)
      .padding(.horizontal, 12)
      .cornerRadius(8)
      .background {
          RoundedRectangle(cornerRadius: 8)
              .fill(Color.primaryBlueBlack)
      }
      .padding(.horizontal, 16)
    }
}

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}

#Preview {
    ToastSample()
}
