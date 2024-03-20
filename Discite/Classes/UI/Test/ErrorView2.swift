//
//  ErrorView2.swift
//  Discite
//
//  Created by Jessie Li on 3/19/24.
//
//  From:
//      https://github.com/nalexn/clean-architecture-swiftui/blob/master/CountriesSwiftUI/UI/Components/ErrorView.swift
//

import SwiftUI

struct ErrorView2: View {
    let error: Error
    let retryAction: () async -> Void
    
    var body: some View {
        VStack {
            Text("An Error Occured")
                .font(.title)
            Text(error.localizedDescription)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40).padding()
            Button(action: {
                Task {
                    await retryAction()
                }
            }, label: { Text("Retry").bold() })
        }
    }
}

#if DEBUG
#Preview {
    ErrorView2(error: NSError(domain: "", code: 0, userInfo: [
        NSLocalizedDescriptionKey: "Something went wrong"]),
              retryAction: { })
}
#endif
