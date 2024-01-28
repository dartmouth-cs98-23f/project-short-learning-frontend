//
//  TopicPageView.swift
//  Discite
//
//  Created by Bansharee Ireen on 1/26/24.
//

import SwiftUI

struct TopicPageView: View {
    @Binding var tabSelection: Navigator.Tab

    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                tabSelection = .Explore
            } label: {
                Text("< Explore")
                    .font(.system(size: 12))
                    .foregroundColor(Color.primaryPurpleDark)
            }
            
            Spacer()
            Button {
                // bookmar/save this topic
            } label: {
                Text("Bookmark")
                    .font(.system(size: 12))
                    .foregroundColor(Color.primaryPurpleDark)
            }
        }
        .padding([.top], 32)
        .padding([.leading, .trailing], 24)
        
        ScrollView {
            LazyVStack(alignment: .center, spacing: 20) {
                Text("Topic")
                    .font(Font.H5)
                    .foregroundColor(Color.primaryPurpleDark)
            
                Text("Basic Auth")
                    .font(Font.H3)
                    .padding([.leading, .trailing], 12)
            }
            .padding([.top, .bottom], 32)
            .padding([.leading, .trailing], 24)
        }
    }
}
