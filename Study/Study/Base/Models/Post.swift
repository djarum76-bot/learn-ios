//
//  Post.swift
//  Study
//
//  Created by habil . on 31/12/23.
//

import Foundation

struct Post: Codable, Identifiable {
    let id, userID: Int
    let image, description: String
    let user: User
    let createdAt: String
    
    var formattedDate: String {
        let inputDateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
//        let outputDateFormat = "MMM dd, yyyy 'at' HH:mm:ss"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputDateFormat
        let date = dateFormatter.date(from: createdAt)!
        
//        dateFormatter.dateFormat = outputDateFormat
//        return dateFormatter.string(from: date)
        
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: currentDate)
        
        if let years = components.year, years > 0 {
            return "\(years) year\(years > 1 ? "s" : "") ago"
        } else if let months = components.month, months > 0 {
            return "\(months) month\(months > 1 ? "s" : "") ago"
        } else if let days = components.day, days > 0 {
            return "\(days) day\(days > 1 ? "s" : "") ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) hour\(hours > 1 ? "s" : "") ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) minute\(minutes > 1 ? "s" : "") ago"
        } else if let seconds = components.second, seconds > 0 {
            return "\(seconds) second\(seconds > 1 ? "s" : "") ago"
        } else {
            return "Just now"
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case image, description, user
        case createdAt = "created_at"
    }
    
    static let example = Post(id: 1, userID: 17, image: "images/Example.jpg", description: "this is we bare bear", user: User.example, createdAt: "2023-12-31 12:49:31.285656+07:00")
}
