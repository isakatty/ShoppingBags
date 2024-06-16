//
//  String+.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/16/24.
//

import Foundation

extension String {
    var htmlEscaped: String {
        guard let encodedData = self.data(using: .utf8) 
        else { return self }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributed = try NSAttributedString(
                data: encodedData,
                options: options,
                documentAttributes: nil
            )
            return attributed.string
        } catch {
            return self
        }
    }
}
