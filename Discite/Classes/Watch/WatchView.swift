//
//  WatchView.swift
//  Discite
//
//  Created by Jessie Li on 10/18/23.
//
//  Source:
//      https://medium.com/mop-developers/build-your-first-swiftui-app-part-5-handling-authorization-95f49cdb0b29

import SwiftUI

struct WatchView: View {
    
    @ObservedObject var viewModel: WatchViewModel = WatchViewModel()
    @Binding var showSidebar: Bool

    var body: some View {
        VStack {
            HStack {
                Button {
                    showSidebar.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(Color.black)
                }
                
                Spacer()
            }
                    
            Spacer()
            Text("Watch View")
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

struct WatchView_Previews: PreviewProvider {
    static var previews: some View {
        WatchView(showSidebar: .constant(false))
    }
}
