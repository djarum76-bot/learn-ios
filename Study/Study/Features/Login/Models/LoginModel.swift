//
//  LoginModel.swift
//  Study
//
//  Created by habil . on 30/12/23.
//

import Foundation

struct LoginModel: Codable {
    let email, password: String

    enum CodingKeys: String, CodingKey {
        case email, password
    }
}
