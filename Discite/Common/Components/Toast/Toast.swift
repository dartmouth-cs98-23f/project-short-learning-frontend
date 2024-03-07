//
//  Toast.swift
//  Discite
//
//  Created by Jessie Li on 2/16/24.
//
//  https://ondrej-kvasnovsky.medium.com/how-to-build-a-simple-toast-message-view-in-swiftui-b2e982340bd
//

import SwiftUI

struct Toast: Equatable {
  var style: ToastStyle
  var message: String
  var duration: Double = 3
  var width: Double = .infinity
}

enum ToastStyle {
  case error
  case warning
  case success
  case info
}

extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .error: return Color.error
        case .warning: return Color.secondaryOrange
        case .info: return Color.primaryPurpleLight
        case .success: return Color.secondaryAqua
        }
    }
    
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}
