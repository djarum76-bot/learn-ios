//
//  EditModel.swift
//  Study
//
//  Created by habil . on 31/12/23.
//

import Foundation

struct EditModel: Codable {
    let id: Int
    let description: String

    enum CodingKeys: String, CodingKey {
        case id, description
    }
}
