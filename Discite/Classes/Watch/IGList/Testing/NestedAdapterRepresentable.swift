//
//  NestedAdapterRepresentable.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//

import SwiftUI

struct NestedAdapterRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = NestedAdapterViewController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

struct NestedAdapterRepresentablePreview: View {
    var body: some View {
        NestedAdapterRepresentable()
    }
}

#Preview {
    NestedAdapterRepresentablePreview()
}
