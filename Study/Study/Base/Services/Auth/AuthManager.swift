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
    
    var id: Int {
        let token = getToken()
        
        if token != "" {
            return decode(jwtToken: getToken())["id"] as! Int
        } else {
            return 0
        }
    }
    
    func setToken(token: String) {
        if getToken() != "" {
            removeToken()
        }
        
        keychain.set(token, forKey: tokenKey)
    }
    
    func removeToken() {
        keychain.removeObject(forKey: tokenKey)
    }
    
    func decode(jwtToken jwt: String) -> [String: Any] {
      let segments = jwt.components(separatedBy: ".")
      return decodeJWTPart(segments[1]) ?? [:]
    }
    
    func decodeJWTPart(_ value: String) -> [String: Any]? {
      guard let bodyData = base64UrlDecode(value),
        let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
          return nil
      }

      return payload
    }

    func base64UrlDecode(_ value: String) -> Data? {
      var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

      let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
      let requiredLength = 4 * ceil(length / 4.0)
      let paddingLength = requiredLength - length
      if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 = base64 + padding
      }
      return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
}
