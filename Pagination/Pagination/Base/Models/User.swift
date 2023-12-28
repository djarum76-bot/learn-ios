//
//  User.swift
//  Pagination
//
//  Created by habil . on 28/12/23.
//

import Foundation

struct User: Identifiable, Codable, Hashable{
    enum CodingKeys: String, CodingKey{
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
    
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String
    
    static let example = User(id: 1, email: "naruto@gmail.com", firstName: "Naruto", lastName: "Uzumaki", avatar: "https://reqres.in/img/faces/1-image.jpg")
}
