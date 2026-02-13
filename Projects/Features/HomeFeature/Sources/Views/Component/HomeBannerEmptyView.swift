//
//  HomeBannerEmptyView.swift
//  HomeFeature
//
//  Created by 최안용 on 2/3/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

final class HomeBannerEmptyView: UIView {
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let titleStackView = UIStackView()
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeBannerEmptyView {
    func setStyle() {
        backgroundColor = .clear
        
        titleLabel.do {
            $0.setText(
                .bodyLSB,
                text: "아직 등록된 여행지가 없어요",
                color: DSKitAsset.Colors.black700.color
            )
        }
        
        subTitleLabel.do {
            $0.setText(
                .bodyMM,
                text: "새 여행 일정을 만들어 보세요!",
                color: DSKitAsset.Colors.black400.color
            )
        }
        
        titleStackView.do {
            $0.axis = .vertical
            $0.spacing = 6.adjustedH
            $0.alignment = .leading
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 4.adjusted
            $0.alignment = .center
        }
        
        imageView.do {
            $0.image = DSKitAsset.Assets.icEmptyTrip.image
        }
    }
    
    func setUI() {
        titleStackView.addArrangedSubviews(titleLabel, subTitleLabel)
        stackView.addArrangedSubviews(titleStackView, imageView)
        addSubviews(stackView)
    }
    
    func setLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(76.adjustedH)
        }
        
        stackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.directionalVerticalEdges.equalToSuperview().inset(2).priority(.high)
        }
    }
}
