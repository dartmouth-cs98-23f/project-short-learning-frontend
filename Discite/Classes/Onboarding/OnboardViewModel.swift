//
//  OnboardViewModel.swift
//  Discite
//
//  Created by Jessie Li on 2/23/24.
//

import Foundation

class OnboardViewModel: ObservableObject {
    @Published var error: Error?
    
    // POST role preferences to API
    func mockSubmitPreferences(parameters: OnboardRolesRequest) async {
        error = nil
        
        do {
            print("TEST: POST role preferences with values \(parameters.values)")
            _ = try await APIRequest<OnboardRolesRequest, EmptyResponse>
                .mockRequest(method: .post,
                             authorized: false,
                             path: "/api/setRolePreferences",
                             parameters: parameters,
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
