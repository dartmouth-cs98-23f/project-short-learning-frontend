//
//  MainAuthPage.swift
//  Discite
//
//  Created by Jessie Li on 2/28/24.
//

import SwiftUI

struct MainAuthPage: View {
    var body: some View {
        NavigationStack {
            LoginPage()
        }
    }
}

#Preview {
    MainAuthPage()
        .environmentObject(User())
}
