//
//  Photo.swift
//  PhotoTaker
//
//  Created by habil . on 25/12/23.
//

import Foundation
import CoreLocation

struct Photo: Identifiable, Codable, Comparable, Hashable{
    let id: UUID
    let name: String
    let image: Data
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func < (lhs: Photo, rhs: Photo) -> Bool {
        lhs.name < rhs.name
    }
}
