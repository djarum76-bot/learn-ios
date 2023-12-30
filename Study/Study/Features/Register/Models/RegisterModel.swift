//
//  RegisterModel.swift
//  Study
//
//  Created by habil . on 30/12/23.
//

import Foundation

struct RegisterModel: Codable {
    let name, email, password: String

    enum CodingKeys: String, CodingKey {
        case name, email, password
    }
}
