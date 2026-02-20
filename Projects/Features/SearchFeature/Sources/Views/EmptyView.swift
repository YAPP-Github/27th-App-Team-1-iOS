//
//  EmptyView.swift
//  SearchFeature
//
//  Created by 최안용 on 2/18/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

final class EmptyView: UIView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let containerStackView = UIStackView()
    private let titleStackView = UIStackView()
    
    private var type: EmptyViewType = .start
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeType(_ type: EmptyViewType) {
        self.type = type
        
        imageView.image = type.image
        
        titleLabel.setText(
            .subTitleMSB,
            text: type.title,
            color: DSKitAsset.Colors.black500.color,
            alignment: .center
        )
        
        subTitleLabel.setText(
            .bodyLR,
            text: type.subTitle,
            color: DSKitAsset.Colors.black400.color,
            alignment: .center
        )
    }
}

private extension EmptyView {
    func setStyle() {
        imageView.do {
            $0.image = type.image
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.setText(
                .subTitleMSB,
                text: type.title,
                color: DSKitAsset.Colors.black500.color,
                alignment: .center
            )
        }
        
        subTitleLabel.do {
            $0.numberOfLines = 0
            $0.setText(
                .bodyLR,
                text: type.subTitle,
                color: DSKitAsset.Colors.black400.color,
                alignment: .center
            )
        }
        
        containerStackView.do {
            $0.axis = .vertical
            $0.spacing = 16.adjustedH
            $0.alignment = .center
        }
        
        titleStackView.do {
            $0.axis = .vertical
            $0.spacing = 4.adjustedH
            $0.alignment = .center
        }
    }
    
    func setUI() {
        titleStackView.addArrangedSubviews(titleLabel, subTitleLabel)
        containerStackView.addArrangedSubviews(imageView, titleStackView)
        addSubviews(containerStackView)
    }
    
    func setLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(100.adjustedH)
        }
        
        containerStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

enum EmptyViewType {
    case start
    case noResults
    
    var image: UIImage {
        switch self {
        case .start:
            DSKitAsset.Assets.icTripBag.image
        case .noResults:
            DSKitAsset.Assets.icEmptySearch.image
        }
    }
    
    var title: String {
        switch self {
        case .start:
            "어디로 떠나볼까요?"
        case .noResults:
            "검색 결과가 없어요"
        }
    }
    
    var subTitle: String {
        switch self {
        case .start:
            "좋아하는 유튜버나 가고 싶은\n여행지를 검색 할 수 있어요."
        case .noResults:
            "철자를 확인하거나\n다른 키워드로 검색해보세요."
        }
    }
}
