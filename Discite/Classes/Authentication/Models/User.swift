//
//  User.swift
//  Discite
//
//  Created by Jessie Li on 10/31/23.
//

import Foundation
import SwiftUI

@MainActor
class User: Identifiable, ObservableObject {
    
    enum KeychainKey: String {
        case token
    }
    
    enum AuthState: String, CaseIterable {
        case signedIn
        case signedOut
        case onboarding
    }
    
    // properties
    private(set) var userId: String = ""
    private(set) var firstName: String = ""
    private(set) var lastName: String = ""
    private(set) var username: String = ""
    private(set) var email: String?
    private(set) var profilePicture: String?
    
    public var fullName: String {
        return self.firstName + " " + self.lastName
    }
    
    // authentication
    var token: String = ""
    @Published var state: AuthState = .signedOut
    @Published var loadingState: ViewModelState = .loading
    
    init() {
        do {
            // try to retrieve token
            self.token = try KeychainItem(account: KeychainKey.token.rawValue).readItem()
            print("Token found: \(token), getting user.")
            Task {
                do {
                    try await getUser(token: self.token)
                    loadingState = .loaded
                } catch {
                    self.loadingState = .error(error: error)
                    print("Error getting user: \(error)")
                }
            }
            
        } catch {
            // Not an error, just no token
            loadingState = .loaded
            print("No token: \(error)")
        }
    }
    
   static func getToken() -> String? {
        do {
            return try KeychainItem(account: KeychainKey.token.rawValue).readItem()
        } catch {
            return nil
        }
    }
    
    public func getUser(token: String) async throws {
        print("GET /api/user")
        let response = try await APIRequest<EmptyRequest, UserData>
            .apiRequest(method: .get,
                        authorized: true,
                        path: "/api/user")
        
        self.username = response.username
        self.firstName = response.firstName
        self.lastName = response.lastName
        self.email = response.email
        
        withAnimation {
            print("Setting user state to signedIn.")
            self.state = response.onBoardingStatus ? .signedIn : .onboarding
        }
    }
    
    func updateUser(request: UpdateUserRequest) async throws {
        print("PUT /api/user")
        
        do {
            // Try updating user on backend
            _ = try await APIRequest<UpdateUserRequest, EmptyResponse>
                .apiRequest(method: .put,
                            authorized: true,
                            path: "/api/user",
                            parameters: request)
            
            // If successful, update user on frontend
            self.firstName = request.firstName
            self.lastName = request.lastName
            self.username = request.username
            self.profilePicture = request.profilePicture
            
        } catch {
            self.loadingState  = .error(error: error)
            print("Error in User.updateUser: \(error)")
        }
    }
    
    public func completeOnboarding() {
        withAnimation {
            state = .signedIn
        }
    }
    
    public func configure() {
        self.userId = "guest"
        self.firstName = "John"
        self.lastName = "Doe"
        self.username = "johndoe"
        self.email = "johndoe@email.com"
        
        withAnimation(.spring) {
            self.state = .onboarding
        }
    }
    
    public func configure(token: String, data: AuthResponseData) throws {
        self.username = data.username
        self.firstName = data.firstName
        self.lastName = data.lastName
        self.email = data.email
        self.profilePicture = data.profilePicture
        self.token = token
        
        try KeychainItem(account: KeychainKey.token.rawValue).saveItem(token)
        
        withAnimation {
            self.state = data.onBoardingStatus ? .signedIn : .onboarding
        }
    }
    
    public func clear() throws {
        self.userId = ""
        self.username = ""
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.profilePicture = ""
        self.token = ""
        
        try KeychainItem(account: KeychainKey.token.rawValue).deleteItem()
        
        withAnimation {
            self.state = .signedOut
        }
    }
    
}

struct Statistic: Codable, Identifiable {
    var id: String?
    var value: String
    var item: String
    var timeframe: String
    
    enum CodingKeys: String, CodingKey {
        case value
        case item
        case timeframe
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(String.self, forKey: .value)
        self.item = try container.decode(String.self, forKey: .item)
        self.timeframe = try container.decode(String.self, forKey: .timeframe)
        
        self.id = UUID().uuidString
    }
}
