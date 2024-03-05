//
//  CustomTabView.swift
//  Discite
//
//  Created by Jessie Li on 2/19/24.
//

import SwiftUI

struct CustomTabView: View {
    @State private var selectedIndex: Int = 0
    let tabItems: [CustomTabItem]

    init(_ tabItems: [CustomTabItem]) {
        self.tabItems = tabItems
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 16) {
                // tabs
                ForEach(tabItems.indices, id: \.self) { index in
                    let selected = index == selectedIndex
                    
                    Button {
                        withAnimation(.smooth) {
                            selectedIndex = index
                        }
                        
                    } label: {
                        Text(tabItems[index].label)
                            .font(.H6)
                            .foregroundStyle(selected ?
                                             Color.primaryPurpleDark
                                             : Color.primaryPurpleLight)
                            // underline
                            .background {
                                if selected {
                                    Rectangle()
                                        .foregroundColor(Color.primaryPurple)
                                        .frame(height: 2)
                                        .padding(.top, 28)
                                }
                            }
                    }
                    
                }
                
                Spacer()
            }
            
            // content
            tabItems[selectedIndex].content
                .padding(.top, 12)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
        
    }
}

struct CustomTabItem {
    let label: String
    let content: AnyView

    init<V: View>(_ label: String, @ViewBuilder content: @escaping () -> V) {
        self.label = label
        self.content = AnyView(content())
    }
}

struct SampleContentPage: View {
    var body: some View {
        Text("Sample page for testing.")
    }
}

struct SampleCustomTabView: View {
    var body: some View {
      
        let tabItems: [CustomTabItem] = [
            CustomTabItem("Tab 1") {
                Text("Tab 1 Content")
            },
            CustomTabItem("Tab 2") {
                Text("Tab 2 Content")
            },
            CustomTabItem("Tab 3") {
                SampleContentPage()
            }
        ]

        CustomTabView(tabItems)
    }
}

#Preview {
    SampleCustomTabView()
}
