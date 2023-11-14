//
//  TestExplore.swift
//  Discite
//
//  Created by Jessie Li on 11/13/23.
//

import SwiftUI

struct TestExplore: View {
    
    @EnvironmentObject var recommendations: Recommendations
    
    var body: some View {
        Text("Successfully fetched recommendations.")
    }
}

#Preview {
    let recommendations = Recommendations()
    return TestExplore().environmentObject(recommendations)
}
