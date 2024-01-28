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
        var smallTextSize = CGFloat(16)
        var topBottom = CGFloat(32)
        var leadTrail = CGFloat(24)
        
        HStack(alignment: .center) {
            Button {
                tabSelection = .Explore
            } label: {
                Text("< Explore")
                    .font(.system(size: smallTextSize))
                    .foregroundColor(Color.primaryPurpleDark)
            }
            
            Spacer()
            Button {
                // bookmar/save this topic
            } label: {
                Text("Bookmark")
                    .font(.system(size: smallTextSize))
                    .foregroundColor(Color.primaryPurpleDark)
            }
        }
        .padding([.top], topBottom)
        .padding([.leading, .trailing], leadTrail)
        
        ScrollView {
            LazyVStack(alignment: .center, spacing: 10) {
                Text("Topic")
                    .font(Font.H5)
                    .foregroundColor(Color.primaryPurpleDark)
            
                Text("Basic Auth")
                    .font(Font.H3)
            }
            .padding([.top, .bottom], topBottom)
            .padding([.leading, .trailing], leadTrail)
        }
    }
}
