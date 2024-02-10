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
    
    func getFriends() async -> [Friend]? {
        self.error = nil
    
        do {
            let response = try await APIRequest<EmptyRequest, FriendsResponse>
                .mockRequest(method: .get,
                            authorized: false,
                            path: "/api/friends")
            
            return response.friends
            
        } catch {
            self.error = error
            print(error)
            return nil
        }
    }
}

struct FriendsResponse: Codable {
    var friends: [Friend]
}
