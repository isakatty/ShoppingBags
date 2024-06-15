//
//  SortedItem.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/15/24.
//

import Foundation

enum SortedItem: String, CaseIterable {
    case accuracy = "정확도"
    case latestDate = "날짜순"
    case highestPrice = "가격높은순"
    case lowestPrice = "가격낮은순"
    
    var query: String {
        switch self {
        case .accuracy:
            "sim"
        case .latestDate:
            "date"
        case .highestPrice:
            "asc"
        case .lowestPrice:
            "dsc"
        }
    }
}
