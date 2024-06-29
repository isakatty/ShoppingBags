//
//  NetworkManager.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/22/24.
//

import Foundation

import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func callRequest(
        searchText: String?,
        startPage: Int,
        sorting: SortedItem,
        completion: @escaping (Search) -> Void
    ) {
        let url = makeURL(
            with: searchText ?? "",
            with: startPage,
            sorting: sorting
        )
        let header = makeHeader()
        
        AF.request(
            url,
            headers: header
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: Search.self) { response in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                // 재검색 유도
                print(error)
            }
        }
    }
    private func makeURL(
        with searchText: String,
        with startPage: Int,
        sorting: SortedItem
    ) -> String {
        let baseURLString = Constant.Endpoint.baseURL
        let queryParams: [String: String] = [
            "query": searchText,
            "display": String(30),
            "start": String(startPage),
            "sort": sorting.query
        ]
        let query = queryParams.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        guard let encodedQuery = query
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else { return "" }
        
        return baseURLString + encodedQuery
    }
    
    private func makeHeader() -> HTTPHeaders {
        let client_ID = Bundle.main.object(
            forInfoDictionaryKey: "NAVER_SEARCH_API_CLIENT_ID"
        ) as? String ?? ""
        let client_Secret = Bundle.main.object(
            forInfoDictionaryKey: "NAVER_SEARCH_API_CLIENT_SECRET"
        ) as? String ?? ""
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": client_ID,
            "X-Naver-Client-Secret": client_Secret
        ]
        return header
    }
}
