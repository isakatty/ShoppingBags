//
//  SortingButton.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/16/24.
//

import UIKit

public final class SortingButton: UIButton {
    
    public var sortCondition: SortedItem = .accuracy
    
    public init(
        titleForButton: SortedItem,
        tag: Int
    ) {
        super.init(frame: .zero)
        
        sortCondition = titleForButton
        
        self.tag = tag
        
        configureUIConstant(titleForButton: sortCondition)
        if sortCondition == .accuracy {
            configureUISelected()
        } else {
            configureUI()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureUIConstant(titleForButton: SortedItem) {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )
        self.titleLabel?.font = Constant.Font.regular13
        self.configuration = config
        setTitle(
            titleForButton.rawValue,
            for: .normal
        )
        layer.borderColor = Constant.Colors.darkGray?.cgColor
        layer.borderWidth = 1
    }
    
    public func configureUI() {
        setTitleColor(
            Constant.Colors.black,
            for: .normal
        )
        backgroundColor = Constant.Colors.white
        self.titleLabel?.textColor = Constant.Colors.black
        
    }
    public func configureUISelected() {
        setTitleColor(
            Constant.Colors.white,
            for: .normal
        )
        backgroundColor = Constant.Colors.darkGray
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
    }
}
