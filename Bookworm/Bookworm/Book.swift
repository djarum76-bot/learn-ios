//
//  Book.swift
//  Bookworm
//
//  Created by habil . on 23/12/23.
//

import Foundation
import SwiftData

@Model
class Book{
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int
    var createdAt: Date = Date.now
    
    init(title: String, author: String, genre: String, review: String, rating: Int) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
    }
}
