//
//  RoundedButton.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/14/24.
//

import UIKit

public final class RoundedButton: UIButton {
    
    public init(titleForButton: String) {
        super.init(frame: .zero)
        
        setTitle(titleForButton, for: .normal)
        setTitleColor(Constant.Colors.white, for: .normal)
        backgroundColor = Constant.Colors.orange
        layer.cornerRadius = 20
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
