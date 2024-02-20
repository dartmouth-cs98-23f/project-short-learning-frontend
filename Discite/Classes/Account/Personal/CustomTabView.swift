//
//  CustomTabView.swift
//  Discite
//
//  Created by Jessie Li on 2/19/24.
//

import SwiftUI

struct CustomTabView<MyContent: View>: View {
    @State private var selectedIndex: Int = 0
    let tabItems: [CustomTabItem<MyContent>]
    
    init(_ tabItems: [CustomTabItem<MyContent>]) {
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
            
            Spacer()
        }
        
    }
}

struct CustomTabItem<MyContent: View> {
    let label: String
    let content: MyContent
    
    init(_ label: String, @ViewBuilder content: () -> MyContent) {
        self.label = label
        self.content = content()
    }
}

struct SampleCustomTabView: View {
    var body: some View {
        let tabItems: [CustomTabItem<Text>] = [
            CustomTabItem("Tab 1", content: { Text("Tab 1 Content") }),
            CustomTabItem("Tab 2", content: { Text("Tab 2 Content") }),
            CustomTabItem("Tab 3", content: { Text("Tab 3 Content") })
        ]

        CustomTabView(tabItems)
    }
}

#Preview {
    SampleCustomTabView()
}
