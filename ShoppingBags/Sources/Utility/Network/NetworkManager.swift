//
//  NetworkManager.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/22/24.
//

import Foundation

import Alamofire

enum NetworkError: Error {
    case invalidURL
    case invalidData
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func requestShopping<T: Decodable>(
        endpoint: ShoppingRequest,
        type: T.Type,
        completionHandler: @escaping (T?, String?) -> Void
    ) {
        guard let url = URL(string: endpoint.toURLString) else {
            print(NetworkError.invalidURL)
            return
        }
        
        AF.request(
            url,
            method: HTTPMethod(rawValue: endpoint.method),
            headers: HTTPHeaders(endpoint.header)
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: type.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value, nil)
            case .failure(_):
                completionHandler(nil, NetworkError.invalidData.localizedDescription)
            }
        }
    }
}
