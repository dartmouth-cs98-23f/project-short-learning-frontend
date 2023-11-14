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
        onboarded = hasOnboarded()
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
    
    // Sets onboarding status to "complete" in keychain
    func setOnboarded() throws {
        let success = keychain.set("complete", forKey: KeychainKey.onboarded.rawValue)
        guard success else { throw AuthError.failedOnboard }
        DispatchQueue.main.async {
            Auth.shared.onboarded = true
        }
    }
    
    func hasToken() -> Bool {
        return getToken() != nil
    }
    
    func hasOnboarded() -> Bool {
        return keychain.string(forKey: KeychainKey.token.rawValue) != nil
    }
    
    func getToken() -> String? {
        return keychain.string(forKey: KeychainKey.token.rawValue)
    }

    func logout() {
        keychain.removeObject(forKey: KeychainKey.token.rawValue)
        loggedIn = false
    }
}
