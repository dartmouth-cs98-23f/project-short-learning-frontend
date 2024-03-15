//
//  SharedViewController.swift
//  Discite
//
//  Created by Jessie Li on 10/22/23.
//

import SwiftUI

struct SharedView: View {

    var body: some View {
        VStack {
            Spacer()
            Text("Shared View")
            Spacer()
        }
        .padding(.horizontal, 24)
        .onAppear {
            print("Shared appear")
        }
        .onDisappear {
            print("Shared disappear")
        }
    }

}
