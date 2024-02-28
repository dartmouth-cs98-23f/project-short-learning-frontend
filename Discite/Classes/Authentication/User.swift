//
//  User.swift
//  Discite
//
//  Created by Jessie Li on 10/31/23.
//

import Foundation
import GoogleSignIn
import SwiftKeychainWrapper
import SwiftUI

class User: Identifiable, ObservableObject {
    
    enum KeychainKey: String {
        case token
    }
    
    enum AuthState: String, CaseIterable, Identifiable {
        case signedIn
        case signedOut
        case onboarding
        
        public var id: String { rawValue }
    }
    
    // properties
    private(set) var id: UUID = UUID()
    private(set) var userId: String = ""
    private(set) var firstName: String = ""
    private(set) var lastName: String = ""
    private(set) var username: String = ""
    private(set) var email: String?
    private(set) var profilePicture: String?
    private(set) var onboarded: Bool = false
    
    public var fullName: String {
        return self.firstName + " " + self.lastName
    }
    
    // authentication
    var token: String = ""
    @Published var state: AuthState = .signedOut
    
    init() {
        do {
            // try to retrieve token
            self.token = try KeychainItem(account: KeychainKey.token.rawValue).readItem()
            
            Task {
                try await getUser(token: self.token)
            }
            
        } catch {
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
        let response = try await APIRequest<EmptyRequest, UserData>
            .mockRequest(method: .get,
                        authorized: true,
                        path: "/api/user")
    }
    
    @MainActor
    public func completeOnboarding() {
        withAnimation {
            state = .signedIn
        }
    }
    
    @MainActor
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
    
    public func configure(data: AuthResponseData) throws {
        self.userId = data.userId
        self.firstName = data.userId
        self.lastName = data.lastName
        self.email = data.email
        self.profilePicture = data.profilePicture
        self.token = data.token
        
        try KeychainItem(account: KeychainKey.token.rawValue).saveItem(token)
        
        withAnimation {
            self.state = .signedIn
        }
    }
    
    public func configure(user: GIDGoogleUser) throws {
        self.userId = user.userID ?? ""
        self.firstName = user.profile?.givenName ?? ""
        self.lastName = user.profile?.familyName ?? ""
        self.email = user.profile?.email ?? ""
        self.profilePicture = user.profile?.imageURL(withDimension: 100)?.absoluteString
        self.token = user.idToken?.tokenString ?? ""
        
        try KeychainItem(account: KeychainKey.token.rawValue).saveItem(token)
        
        withAnimation {
            self.state = .signedIn
        }
    }
    
    @MainActor
    public func clear() throws {
        self.userId = ""
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.profilePicture = ""
        
        try KeychainItem(account: KeychainKey.token.rawValue).deleteItem()
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
