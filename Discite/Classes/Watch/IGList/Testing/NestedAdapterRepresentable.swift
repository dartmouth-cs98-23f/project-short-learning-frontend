//
//  NestedAdapterRepresentable.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//

import SwiftUI

struct NestedAdapterRepresentable: UIViewControllerRepresentable {
    var viewModel: SequenceViewModel
    @Binding var state: ViewModelState
    
    class Coordinator: NSObject {
       var parent: NestedAdapterRepresentable

       init(_ parent: NestedAdapterRepresentable) {
           self.parent = parent
       }
        
        func stateUpdate(_ controller: NestedAdapterViewController, didLoad success: Bool, error: Error?) {
        
        }
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = NestedAdapterViewController(viewModel: viewModel)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

struct NestedAdapterRepresentablePreview: View {
    var viewModel = SequenceViewModel()
    @State var state: ViewModelState = .loading
    
    var body: some View {
        NestedAdapterRepresentable(viewModel: viewModel, state: $state)
    }
}

#Preview {
    NestedAdapterRepresentablePreview()
        .environment(TabSelectionManager(selection: .Watch))
}
