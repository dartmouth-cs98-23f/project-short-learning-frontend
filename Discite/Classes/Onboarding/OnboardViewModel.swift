//
//  OnboardViewModel.swift
//  Discite
//
//  Created by Jessie Li on 2/23/24.
//

import Foundation

class OnboardViewModel: ObservableObject {
    @Published var error: Error?
    @Published var resetGraph: Bool = false
    
    var values: [CGFloat] = [0.8, 0.8, 1.0, 0.7, 0.9, 0.75]
    let defaultValues: [CGFloat] = [0.8, 0.8, 1.0, 0.7, 0.9, 0.75]
    let roles: [String] = ["Front", "Backend", "ML", "AI/Data", "DevOps", "QA"]
    
    func resetGraphValues() {
        print("pressed reset")
        values = defaultValues
        resetGraph.toggle()
    }
    
    // POST role preferences to API
    func mockSubmitPreferences() async {
        error = nil
        let onboardRequest = OnboardRolesRequest(roles: roles, values: values)
        
        do {
            print("TEST: POST role preferences with values \(values)")
            _ = try await APIRequest<OnboardRolesRequest, EmptyResponse>
                .mockRequest(method: .post,
                             authorized: false,
                             path: "/api/setRolePreferences",
                             parameters: onboardRequest,
                             headers: [:])
        } catch {
            self.error = error
            print("Error in OnboardViewModel.mockSubmitPreferences: \(error)")
        }
    }
}

struct OnboardRolesRequest: Codable {
    var roles: [String]
    var values: [CGFloat]
}
