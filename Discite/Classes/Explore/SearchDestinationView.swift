//
//  SearchDestinationView.swift
//  Discite
//
//  Created by Bansharee Ireen on 2/13/24.
//

import SwiftUI

struct SearchDestinationView: View {
    var searchText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Results for ").fontWeight(.semibold).font(.H3)
            +
            Text(searchText).font(.H3)
        }
        
        Spacer()
    }
}
