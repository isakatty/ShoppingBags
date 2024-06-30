//
//  NetworkManager.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/22/24.
//

import Foundation

//import Alamofire

enum NetworkError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
    case failedRequest
    case invalidRequest
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    /* MARK: Alamofire를 사용한 request method
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
    */
    func requestShopping<T: Decodable>(
        endpoint: ShoppingRequest,
        type: T.Type,
        completionHandler: @escaping (T?, NetworkError?) -> Void
    ) {
        guard let url = URL(string: endpoint.toURLString) else {
            print(NetworkError.invalidURL.localizedDescription.description)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.allHTTPHeaderFields = endpoint.header
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("network Error")
                    completionHandler(nil, .failedRequest)
                    return
                }
                guard let data else {
                    print("데이터 없음")
                    completionHandler(nil, .invalidData)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    print("response error")
                    completionHandler(nil, .invalidResponse)
                    return
                }
                guard response.statusCode == 200 else {
                    completionHandler(nil, .failedRequest)
                    return
                }
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(result, nil)
                } catch {
                    completionHandler(nil, .invalidData)
                }
            }
        }.resume()
    }
}
