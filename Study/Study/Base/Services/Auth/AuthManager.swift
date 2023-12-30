//
//  Auth.swift
//  Study
//
//  Created by habil . on 29/12/23.
//

import Foundation
import SwiftKeychainWrapper

class AuthManager: ObservableObject {
    static let shared: AuthManager = AuthManager()
    
    private let keychain: KeychainWrapper = KeychainWrapper.standard
    private let tokenKey = "token"
    
    func getToken() -> String {
        return keychain.string(forKey: tokenKey) ?? ""
    }
    
    func setToken(token: String) {
        if getToken() != "" {
            removeToken()
        }
        
        keychain.set(token, forKey: tokenKey)
    }
    
    func removeToken() {
        keychain.removeObject(forKey: tokenKey)
        keychain.removeAllKeys()
    }
}
