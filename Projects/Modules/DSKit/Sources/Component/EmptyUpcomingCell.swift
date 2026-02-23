//
//  EmptyUpcomingCell.swift
//  DSKit
//
//  Created by 최안용 on 2/23/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

public final class EmptyUpcomingCell: UICollectionViewCell {
    public static let defaultWidth = 328.adjusted
    public static let defaultHeight = 216.adjustedH
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let searchBtn = UIButton()
    
    private let titleStackView = UIStackView()
    private let subStackView = UIStackView()
    private let containerStackView = UIStackView()
    
    public var disposeBag = DisposeBag()
    
    public var buttonDidTap: Observable<Void> {
        searchBtn.rx.tap.asObservable()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}

private extension EmptyUpcomingCell {
    func setStyle() {
        imageView.do {
            $0.image = DSKitAsset.Assets.icTripBag.image
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.setText(
                .subTitleMSB,
                text: "아직 예정된 여행이 없어요.",
                color: DSKitAsset.Colors.black500.color,
                alignment: .center
            )
        }
        
        subtitleLabel.do {
            $0.setText(
                .bodyLR,
                text: "따라가기 영상을 담아두면 여행 준비가 쉬워져요.",
                color: DSKitAsset.Colors.black400.color,
                alignment: .center
            )
        }
        
        searchBtn.do {
            var config = UIButton.Configuration.plain()
            config.background.backgroundColor = DSKitAsset.Colors.black200.color
            
            var fontAttributes = UIFont.NDGL.bodyMSB.attributes
            fontAttributes[.foregroundColor] = DSKitAsset.Colors.black800.color
            
            config.attributedTitle = AttributedString(
                "새로운 여행지 찾아보기",
                attributes: AttributeContainer(fontAttributes)
            )
            
            config.image = DSKitAsset.Assets.icSearch1.image.resize(targetSize: 20.adjusted)
            config.imagePlacement = .trailing
            config.imagePadding = 8.adjusted
            
            config.background.cornerRadius = 8.adjustedH
            config.contentInsets = NSDirectionalEdgeInsets(
                top: 10.adjustedH,
                leading: 16.adjusted,
                bottom: 10.adjustedH,
                trailing: 16.adjusted
            )
            $0.configuration = config
        }
        
        titleStackView.do {
            $0.axis = .vertical
            $0.spacing = 4.adjustedH
            $0.alignment = .center
        }
        
        subStackView.do {
            $0.axis = .vertical
            $0.spacing = 12.adjustedH
            $0.alignment = .center
        }
        
        containerStackView.do {
            $0.axis = .vertical
            $0.spacing = 16.adjustedH
            $0.alignment = .center
        }
    }
    
    func setUI() {
        titleStackView.addArrangedSubviews(titleLabel, subtitleLabel)
        subStackView.addArrangedSubviews(titleStackView, searchBtn)
        containerStackView.addArrangedSubviews(imageView, subStackView)
        contentView.addSubview(containerStackView)
    }
    
    func setLayout() {
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(100.adjustedH)
        }
        
        searchBtn.snp.makeConstraints {
            $0.width.equalTo(184.adjusted)
            $0.height.equalTo(40.adjustedH)
        }
    }
}
