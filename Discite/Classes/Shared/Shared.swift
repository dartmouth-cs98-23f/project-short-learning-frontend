//
//  Shared.swift
//  Discite
//
//  Created by Jessie Li on 11/12/23.
//

import SwiftUI

struct Shared: View {
    
    var sampleShared: [SharedPlaylist] = []
    
    init() {
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    
                    Text("Shared.Title")
                        .font(Font.H2)
                        .padding(.top, 18)
                        .padding([.leading, .trailing], 12)
                    
                    ForEach(self.sampleShared) { sharedPlaylist in
                        SharedCard(sharedPlaylist: sharedPlaylist)
                    }
                }
                .padding([.top, .bottom], 32)
                .padding([.leading, .trailing], 24)
            }
        }
        
        NavigationBar()
    }
    
}

#Preview {
    Shared()
        .environment(TabSelectionManager(selection: .Shared))
}
