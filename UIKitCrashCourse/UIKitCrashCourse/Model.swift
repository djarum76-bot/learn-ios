//
//  Model.swift
//  UIKitCrashCourse
//
//  Created by habil . on 22/01/24.
//

import Foundation

struct UsersResponse: Codable{
    let data: [PersonResponse]
}

struct PersonResponse: Codable{
    let email: String
    let firstName: String
    let lastName: String
}
