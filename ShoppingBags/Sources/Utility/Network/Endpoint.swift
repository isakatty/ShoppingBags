//
//  Endpoint.swift
//  ShoppingBags
//
//  Created by Jisoo HAM on 6/29/24.
//

import Foundation

enum Scheme: String {
    case http, https
}

enum _HTTPMethod {
    case get, put, post, patch, delete
    
    var toString: String {
        switch self {
        case .get:
            return "GET"
        case .put:
            return "PUT"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}

protocol Endpoint {
    var scheme: Scheme { get }
    var host: String { get }
    var path: String { get }
    var port: String { get }
    var query: [String: Any] { get }
    var header: [String: String] { get }
    var method: String { get }
}
