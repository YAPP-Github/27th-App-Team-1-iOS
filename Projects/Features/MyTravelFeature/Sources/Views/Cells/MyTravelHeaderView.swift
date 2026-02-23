//
//  MyTravelHeaderView.swift
//  MyTravelFeature
//
//  Created by 최안용 on 2/23/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

final class MyTravelHeaderView: UICollectionReusableView {
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
    }
    
    func configure(title: String) {
        titleLabel.do {
            $0.setText(.subTitleLSB, text: title, color: DSKitAsset.Colors.black900.color)
        }
    }
}

private extension MyTravelHeaderView {
    func setStyle() {
        titleLabel.do {
            $0.numberOfLines = 2
        }
    }
    
    func setUI() {
        addSubview(titleLabel)
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.directionalVerticalEdges.equalToSuperview()
        }
    }
}
