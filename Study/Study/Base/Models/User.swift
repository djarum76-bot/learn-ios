//
//  User.swift
//  Study
//
//  Created by habil . on 29/12/23.
//

import Foundation

struct User: Codable {
    let id: Int
    let email, name, createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, email, name
        case createdAt = "created_at"
    }
}
