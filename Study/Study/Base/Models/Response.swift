//
//  Response.swift
//  Study
//
//  Created by habil . on 29/12/23.
//

import Foundation

struct Response<T: Codable>: Codable {
    let status: Int
    let message: String
    let data: T
}
