//
//  Endpoint.swift
//  Pagination
//
//  Created by habil . on 28/12/23.
//

import Foundation

enum Endpoint {
    case people(page: Int)
    case detail(id: Int)
}

extension Endpoint {
    var host: String { "reqres.in" }
    
    var path: String {
        switch self {
        case .people:
            return "/api/users"
        case .detail(let id):
            return "/api/users/\(id)"
        }
    }
    
    var queryItems: [String: String]? {
        switch self {
        case .people(let page):
            return [
                "page": "\(page)",
                "per_page": "12"
            ]
        default:
            return nil
        }
    }
    
    var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
            
        var requestQueryItems = [URLQueryItem]()
            
        queryItems?.forEach { item in
            requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
        }
            
        urlComponents.queryItems = requestQueryItems
            
        return urlComponents.url!
    }
}
