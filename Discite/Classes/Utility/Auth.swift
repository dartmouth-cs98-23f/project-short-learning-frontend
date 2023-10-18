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
    
    struct Credentials {
        var token: String?
        var userId: String?
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
    
    func getCredentials() -> Credentials {
        return Credentials(
            token: keychain.string(forKey: KeychainKey.token.rawValue)
        )
    }
    
    // Stores token in keychain
    func setCredentials(credentials: Credentials) -> Bool {
        if (credentials.token == nil) { return false }
        
        let success = keychain.set(credentials.token!, forKey: KeychainKey.token.rawValue)
        if (success) {
            loggedIn = true
            return true
        }
        
        return false
    }
    
    func hasToken() -> Bool {
        return getCredentials().token != nil
    }
    
    func getToken() -> String? {
        return getCredentials().token
    }

    func logout() {
        keychain.removeObject(forKey: KeychainKey.token.rawValue)
        loggedIn = false
    }
}
