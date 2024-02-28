//
//  Auth.swift
//  Discite
//
//  Created by Jessie Li on 10/17/23.
//
//  Source:
//      https://github.com/jrendel/SwiftKeychainWrapper/blob/develop/README.md

import Foundation
import SwiftKeychainWrapper


class Auth: ObservableObject {
    
    enum AuthError: Error {
        case noToken
        case setToken
        case failedOnboard
    }
    
    enum KeychainKey: String {
        case token
        case onboarded
    }
    
    static let shared: Auth = Auth()
    private let keychain: KeychainTools = KeychainTools()
    
    @Published var loggedIn: Bool = false
    @Published var onboarded: Bool = false
    @Published var playlist: Playlist?
    
    private init() {
        loggedIn = hasToken()
    }
    
    // Stores token in keychain
    func setToken(token: String?) throws {
        guard token != nil else { throw AuthError.noToken }
        
        let success = keychain.set(token!, forKey: KeychainKey.token.rawValue)
        guard success else { throw AuthError.setToken }
        Auth.shared.loggedIn = true
//        DispatchQueue.main.async {
//            Auth.shared.loggedIn = true
//        }
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
        onboarded = false
    }
}
