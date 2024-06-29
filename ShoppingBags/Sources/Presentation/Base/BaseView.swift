//
//  BaseView.swift
//  ShoppingBags
//
//  Created by Jisoo HAM on 6/29/24.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureView() {
        backgroundColor = .systemBackground
    }
}
