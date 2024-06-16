//
//  SortingButton.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/16/24.
//

import UIKit

public final class SortingButton: UIButton {
    
    public var sortCondition: SortedItem?
    
    public init(
        titleForButton: SortedItem?,
        tag: Int
    ) {
        super.init(frame: .zero)
        
        guard let sortCondition = titleForButton else { return }
        
        configureUI(
            titleForButton: sortCondition,
            tag: tag
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(
        titleForButton: SortedItem,
        tag: Int
    ) {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )
        self.titleLabel?.font = Constant.Font.regular13
        setTitle(titleForButton.rawValue, for: .normal)
        setTitleColor(Constant.Colors.white, for: .normal)
        backgroundColor = Constant.Colors.darkGray
        layer.borderColor = Constant.Colors.darkGray?.cgColor
        layer.borderWidth = 1
        
        self.tag = tag
        
        self.configuration = config
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
    }
}
