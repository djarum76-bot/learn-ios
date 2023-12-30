//
//  Endpoint.swift
//  Study
//
//  Created by habil . on 29/12/23.
//

import Foundation

enum Endpoint {
    case register(submissionData: Data?)
    case login(submissionData: Data?)
    case getUser
}

extension Endpoint {
    enum MethodType: Equatable {
        case GET
        case POST(data: Data?)
    }
}

extension Endpoint {
    
    var host: String { "192.168.100.177" }
    
    var path: String {
        switch self {
        case .register:
            return "/register"
        case .login:
            return "/login"
        case .getUser:
            return "/auth/user"
        }
    }
    
    var methodType: MethodType {
        switch self {
        case .getUser:
            return .GET
        case .register(let data), .login(let data):
            return .POST(data: data)
        }
    }
}

extension Endpoint {
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = host
        urlComponents.port = 8090
        urlComponents.path = path
        return urlComponents.url
    }
}

extension URL {
    var isAuthorized: Bool {
        return self.absoluteString.contains("/auth/")
    }
}
