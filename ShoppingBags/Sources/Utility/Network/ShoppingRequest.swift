//
//  ShoppingRequest.swift
//  ShoppingBags
//
//  Created by Jisoo HAM on 6/30/24.
//

import Foundation

enum ShoppingRequest: Endpoint {
    static let clientID = Bundle.main.object(
        forInfoDictionaryKey: "NAVER_SEARCH_API_CLIENT_ID"
    ) as? String ?? ""
    static let clientSecret = Bundle.main.object(
        forInfoDictionaryKey: "NAVER_SEARCH_API_CLIENT_SECRET"
    ) as? String ?? ""
    
    case naverShopping(searchText: String, startPage: Int, sort: SortedItem)
    
    var scheme: Scheme {
        .https
    }
    var host: String {
        "openapi.naver.com"
    }
    var path: String {
        "/v1/search/shop.json"
    }
    var port: String {
        ""
    }
    var query: [String: Any] {
        switch self {
        case .naverShopping(let searchText, let startPage, let sort):
            [
                "query": searchText,
                "display": String(30),
                "start": String(startPage),
                "sort": sort.query
            ]
        }
    }
    var header: [String: String] {
        [
            "X-Naver-Client-Id": ShoppingRequest.clientID,
            "X-Naver-Client-Secret": ShoppingRequest.clientSecret
        ]
    }
    var method: String {
        _HTTPMethod.get.toString
    }
    var toURLString: String {
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme.rawValue
        urlComponent.host = host
        urlComponent.port = Int(port)
        urlComponent.path = path
        if !query.isEmpty {
            urlComponent.queryItems = query.map {
                URLQueryItem(name: $0.key, value: $0.value as? String)
            }
        }
        
        return urlComponent.url?.absoluteString ?? ""
    }
}
