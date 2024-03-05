//
//  FriendsViewModel.swift
//  Discite
//
//  Created by Jessie Li on 2/9/24.
//

import Foundation

class FriendsViewModel: ObservableObject {
    @Published var error: Error?
    @Published var searchText: String = ""
    
    @MainActor
    func getFriends() async -> [Friend]? {
        self.error = nil
    
        do {
            let response = try await APIRequest<EmptyRequest, FriendsResponse>
                .apiRequest(method: .get,
                            authorized: true,
                            path: "/api/friends")
            
            return response.friends
            
        } catch {
            self.error = error
            print("Error in FriendsViewModel.getFriends: \(error)")
            return nil
        }
    }
}

struct FriendsResponse: Codable {
    var friends: [Friend]
}
