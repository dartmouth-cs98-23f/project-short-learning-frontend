//
//  SearchResultsPage.swift
//  Discite
//
//  Created by Jessie Li on 2/10/24.
//

import SwiftUI

struct SearchResultsPage: View {
    var searchQuery: String
    
    var body: some View {
        Text(searchQuery)
    }
}

#Preview {
    SearchResultsPage(searchQuery: "auth")
}
