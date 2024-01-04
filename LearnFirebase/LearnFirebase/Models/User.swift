//
//  User.swift
//  LearnFirebase
//
//  Created by habil . on 04/01/24.
//

import Foundation

struct User: Identifiable, Hashable{
    let id: String
    let name: String
    let email: String
    let age: Int
}
