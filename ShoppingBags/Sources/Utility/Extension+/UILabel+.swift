//
//  UILabel+.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/18/24.
//

import UIKit

extension UILabel {
    func highlightedText(
        targetString: String,
        font: UIFont
    ) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(
            .font,
            value: font,
            range: range
        )
        attributedText = attributedString
    }
}
