//
//  SearchResultHeaderView.swift
//  SearchFeature
//
//  Created by 최안용 on 2/18/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

final class SearchResultHeaderView: UICollectionReusableView {
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
    
    func configure(count: Int) {
        titleLabel.do {
            $0.setText(.bodyMM, text: "총 \(count)개", color: DSKitAsset.Colors.black400.color)
        }
    }
}

private extension SearchResultHeaderView {
    func setStyle() {
        titleLabel.do {
            $0.numberOfLines = 1
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

