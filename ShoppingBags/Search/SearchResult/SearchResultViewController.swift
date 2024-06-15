//
//  SearchResultViewController.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import UIKit

import Alamofire

public final class SearchResultViewController: UIViewController {
    public var searchedText: String?
    private var page: Int = 1
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let searchedText else { return }
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        callRequest(searchText: searchedText, startPage: page)
    }
    
    private func configureHierarchy() {
        
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        let safeArea = view.safeAreaLayoutGuide
        
    }
    private func configureNavigationBar() {
        navigationItem.title = searchedText
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Constant.SystemImages.leftChevron,
            style: .plain,
            target: self,
            action: #selector(customBackBtnTapped)
        )
        navigationController?
            .interactivePopGestureRecognizer?.delegate = nil
        navigationController?.navigationBar.tintColor = Constant.Colors.black
    }
    private func callRequest(
        searchText: String,
        startPage: Int
    ) {
        let url = makeURL(
            with: searchText,
            with: startPage
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
                print(value)
            case .failure(let error):
                // 재검색 유도
                print(error)
            }
        }
    }
    
    private func makeURL(
        with searchText: String,
        with startPage: Int
    ) -> String {
        let baseURLString = Constant.Endpoint.baseURL
        let queryParams: [String: String] = [
            "query" : searchText,
            "display" : String(30),
            "start" : String(startPage)
        ]
        let query = queryParams.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        print(query)
        return baseURLString + query
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
    @objc private func customBackBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
