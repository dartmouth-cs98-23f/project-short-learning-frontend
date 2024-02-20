//
//  CustomTabView.swift
//  Discite
//
//  Created by Jessie Li on 2/19/24.
//

import SwiftUI

struct CustomTabView: View {
    @State private var selectedIndex: Int = 0
    // let tabItems: [CustomTabItem<Content>]
    let tabItems: [CustomTabItem]

//    init(_ tabItems: [CustomTabItem<Content>]) {
//        self.tabItems = tabItems
//    }
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
                        withAnimation(.smooth(duration: 0.1)) {
                            selectedIndex = index
                        }
                        
                    } label: {
                        Text(tabItems[index].label)
                            .font(selected ? .H5 : .H6)
                            .foregroundStyle(selected ?
                                             Color.primaryBlueBlack
                                             : Color.primaryPurpleLight)
                            // underline
                            .background {
                                if selected {
                                    Rectangle()
                                        .foregroundColor(Color.primaryBlueBlack)
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
                .frame(maxWidth: .infinity, alignment: .leading)
            
//            tabItems[selectedIndex].content()
//                .frame(maxWidth: .infinity, alignment: .leading)
            
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
