//
//  TestTabView.swift
//  Discite
//
//  Created by Jessie Li on 2/19/24.
//

import SwiftUI

struct TestTabView<Content: View>: View {
    let tabItems: [CustomTabItem<Content>]

    @State private var selectedIndex: Int = 0

    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(0..<tabItems.count, id: \.self) { index in
                tabItems[index].view
                    .tabItem {
                        Text(tabItems[index].label)
                    }
                    .tag(index)
            }
        }
    }
}

struct CustomTabItem<Content: View> {
    let label: String
    let view: Content
}

#Preview {
    TestTabView(tabItems: [
        CustomTabItem(label: "Tab 1", view: Text("Content 1")),
        CustomTabItem(label: "Tab 2", view: Text("Content 2"))
        // Add more tab items as needed
    ])
}
