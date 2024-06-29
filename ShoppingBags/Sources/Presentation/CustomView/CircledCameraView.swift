//
//  CircledCameraView.swift
//  ShoppingBags
//
//  Created by Jisoo Ham on 6/14/24.
//

import UIKit

public final class CircledCameraView: UIView {
    private let cameraImg: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "camera.fill")?
            .withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Constant.Colors.white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubview(cameraImg)
    }
    private func configureLayout() {
        backgroundColor = Constant.Colors.orange
        clipsToBounds = true
        
        cameraImg.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(3)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
    }
    
}
