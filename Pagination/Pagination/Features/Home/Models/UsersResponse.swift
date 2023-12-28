//
//  UsersResponse.swift
//  Pagination
//
//  Created by habil . on 28/12/23.
//

import Foundation

struct UsersResponse: Codable{
    enum CodingKeys: String, CodingKey{
        case totalPages = "total_pages"
        case data
    }
    
    let totalPages: Int
    let data: [User]
}
