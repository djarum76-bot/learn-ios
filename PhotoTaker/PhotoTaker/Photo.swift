//
//  Photo.swift
//  PhotoTaker
//
//  Created by habil . on 25/12/23.
//

import Foundation

struct Photo: Identifiable, Codable, Comparable, Hashable{
    let id: UUID
    let name: String
    let image: Data
    
    static func < (lhs: Photo, rhs: Photo) -> Bool {
        lhs.name < rhs.name
    }
}
