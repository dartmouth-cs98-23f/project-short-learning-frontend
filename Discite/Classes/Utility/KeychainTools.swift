//
//  Auth.swift
//  Discite
//
//  Created by Jessie Li on 10/17/23.
//  References:
//      https://github.com/jrendel/SwiftKeychainWrapper/blob/develop/SwiftKeychainWrapper/KeychainWrapper.swift
//      https://developer.apple.com/documentation/security/keychain_services/keychain_items/adding_a_password_to_the_keychain
//      https://medium.com/mop-developers/build-your-first-swiftui-app-part-5-handling-authorization-95f49cdb0b29

import Foundation

class KeychainTools {

    private let SecMatchLimit: String! = kSecMatchLimit as String
    private let SecReturnData: String! = kSecReturnData as String
    private let SecValueData: String! = kSecValueData as String
    private let SecClass: String! = kSecClass as String
    private let SecAttrService: String! = kSecAttrService as String
    private let SecAttrAccount: String! = kSecAttrAccount as String
    
    private (set) public var serviceName: String
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unhandledError(status: OSStatus)
    }
    
    // Default serviceName is the app bundle identifier
    public init(serviceName: String? = nil) {
        self.serviceName = serviceName ?? Bundle.main.bundleIdentifier ?? "KeychainTools"
    }
    
    // MARK: Public Getters
    
    // Returns string value for a specified key
    open func string(forKey key: String) -> String? {
        guard let keychainData = data(forKey: key) else {
            return nil
        }
          
        return String(data: keychainData, encoding: String.Encoding.utf8) as String?
    }
    
    // Returns a Data object for a specified key
    open func data(forKey key: String) -> Data? {
        var query = createKeychainQuery(forKey: key)
        
        // Limit search results to one
        query[SecMatchLimit] = kSecMatchLimitOne
                
        // Specify we want Data/CFData returned
        query[SecReturnData] = kCFBooleanTrue
                
        // Search
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
                
        return status == noErr ? result as? Data : nil
    }
    
    // MARK: Public Setters
    
    // Save a String value to the keychain associated with a specified key.
    // If a String value already exists for the given key, the string will be overwritten with the new value.
    @discardableResult open func set(_ value: String, forKey key: String) -> Bool {
        if let data = value.data(using: String.Encoding.utf8) {
            return set(data, forKey: key)
        }
        
        return false
    }
    
    // Save a Data object to the keychain associated with a specified key.
    // If data already exists for the given key, the data will be overwritten with the new value.
     @discardableResult open func set(_ value: Data, forKey key: String) -> Bool {
         var query: [String: Any] = createKeychainQuery(forKey: key)
         
         query[SecValueData] = value
         
         let status: OSStatus = SecItemAdd(query as CFDictionary, nil)

         if status == errSecDuplicateItem {
             return update(value, forKey: key)
         }
         
         return status == errSecSuccess
     }
    
    // Remove an object associated with a specified key.
    @discardableResult open func removeObject(forKey key: String) -> Bool {
        let query: [String: Any] = createKeychainQuery(forKey: key)

        // Delete
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    // MARK: Private Methods
    
    // Update existing data associated with a specified key name. The existing data will be overwritten by the new data.
    private func update(_ value: Data, forKey key: String) -> Bool {
        var query: [String: Any] = createKeychainQuery(forKey: key)
        let updateDictionary = [SecValueData: value]
            
        // Update
        let status: OSStatus = SecItemUpdate(query as CFDictionary, updateDictionary as CFDictionary)
        return status == errSecSuccess
    }
    
    // Setup the keychain query dictionary used to access the keychain on iOS for a specified key name.
    private func createKeychainQuery(forKey key: String) -> [String: Any] {

        var query: [String: Any] = [
            SecClass: kSecClassGenericPassword,         // Default access is generic password
            SecAttrService: serviceName                 // Uniquely identify this keychain accessor
        ]
        
        // Specifies the key to the value we want to store
        let encodedIdentifier: Data? = key.data(using: String.Encoding.utf8)
        query[SecAttrAccount] = encodedIdentifier
        
        return query
    }
}
