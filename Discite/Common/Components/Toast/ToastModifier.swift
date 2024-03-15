//
//  ToastModifier.swift
//  Discite
//
//  Created by Jessie Li on 2/16/24.
// 
//  https://ondrej-kvasnovsky.medium.com/how-to-build-a-simple-toast-message-view-in-swiftui-b2e982340bd
//

import SwiftUI

struct ToastModifier: ViewModifier {

    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?

    func body(content: Content) -> some View {
        ZStack {
            content
                .onChange(of: toast, {
                    showToast()
                })

            mainToastView()
                .padding(.bottom, 18)
                .animation(.spring(duration: 0.2), value: toast)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .containerRelativeFrame([.horizontal, .vertical])
    }

    @ViewBuilder
    func mainToastView() -> some View {
        if let toast = toast {
            ToastView(
                style: toast.style,
                message: toast.message,
                width: toast.width
            ) {
                dismissToast()
            }
        }
    }

    private func showToast() {
        guard let toast = toast else { return }

        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()

        if toast.duration > 0 {
            workItem?.cancel()

            let task = DispatchWorkItem {
                dismissToast()
            }

            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }

    private func dismissToast() {
        withAnimation { toast = nil }
        workItem?.cancel()
        workItem = nil
    }
}

#Preview {
    ToastSample()
}
