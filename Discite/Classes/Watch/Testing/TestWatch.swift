//
//  TestWatch.swift
//  Discite
//
//  Created by Jessie Li on 11/13/23.
//

import SwiftUI

struct TestWatch: View {
    var body: some View {
        Text("Testing playlists.")
    }
}

#Preview {
    let sequence = Sequence()
    sequence.addPlaylists()
    return TestWatch()
}
