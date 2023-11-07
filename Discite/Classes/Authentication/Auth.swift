//
//  Auth.swift
//  Discite
//
//  Created by Jessie Li on 10/17/23.
//
//  Source:
//      https://medium.com/mop-developers/build-your-first-swiftui-app-part-5-handling-authorization-95f49cdb0b29

import Foundation

class Auth: ObservableObject {
    
    enum AuthError: Error {
        case noToken
        case setToken
    }
    
    enum KeychainKey: String {
        case token
        case userId
    }
    
    static let shared: Auth = Auth()
    private let keychain: KeychainTools = KeychainTools()
    
    @Published var loggedIn: Bool = false
    
    private init() {
        loggedIn = hasToken()
    }
    
    // Stores token in keychain
    func setToken(token: String?) throws {
        guard token != nil else { throw AuthError.noToken }
        
        let success = keychain.set(token!, forKey: KeychainKey.token.rawValue)
        guard success else { throw AuthError.setToken }
        DispatchQueue.main.async {
            Auth.shared.loggedIn = true
        }
    }
    
    func hasToken() -> Bool {
        return getToken() != nil
    }
    
    func getToken() -> String? {
        return keychain.string(forKey: KeychainKey.token.rawValue)
    }

    func logout() {
        keychain.removeObject(forKey: KeychainKey.token.rawValue)
        loggedIn = false
    }
}
