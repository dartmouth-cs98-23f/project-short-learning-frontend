//
//  NestedAdapterRepresentable.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//

import SwiftUI

struct NestedAdapterRepresentable: UIViewControllerRepresentable {
    var viewModel: SequenceViewModel

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = NestedAdapterViewController(viewModel: viewModel)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

    }
}

struct NestedAdapterRepresentablePreview: View {
    @StateObject var viewModel = SequenceViewModel()

    var body: some View {
        NestedAdapterRepresentable(viewModel: viewModel)
    }
}

#Preview {
    NestedAdapterRepresentablePreview()
        .environment(TabSelectionManager(selection: .Watch))
}
