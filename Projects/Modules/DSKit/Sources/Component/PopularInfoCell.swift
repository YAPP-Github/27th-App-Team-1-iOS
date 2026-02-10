//
//  PopularInfoCell.swift
//  DSKit
//
//  Created by 최안용 on 1/30/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import Kingfisher

public final class PopularInfoCell: UICollectionViewCell {
    public static let defaultHeight = 88.adjustedH
    
    private let thumbnailView = UIImageView()
    private let nationalFlagLabel = UILabel()
    private let nationLabel = UILabel()
    private let nationStackView = UIStackView()
    private let titleLabel = UILabel()
    private let cityLabel = UILabel()
    private let dotLabel = UILabel()
    private let scheduleLabel = UILabel()
    private let infoStackView = UIStackView()
    private let textContainerStackView = UIStackView()
    
    override public init(frame: CGRect) {
        super.init(frame: .zero)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailView.kf.cancelDownloadTask()
        thumbnailView.image = nil
        nationalFlagLabel.text = nil
        cityLabel.text = nil
        titleLabel.text = nil
        nationLabel.text = nil
        scheduleLabel.text = nil
    }
    
    public func configure(
        thumbnailUrl: String,
        city: String,
        title: String,
        nation: String,
        schedule: String
    ) {
        if let url = URL(string: thumbnailUrl) {
            thumbnailView.kf.setImage(with: url, options: [.transition(.fade(0.3))])
        }
        
        nationalFlagLabel.text = nation.toFlag()
        cityLabel.setText(.bodyMM, text: city, color: DSKitAsset.Colors.black400.color)
        titleLabel.setText(.bodyLM, text: title, color: DSKitAsset.Colors.black800.color)
        nationLabel.setText(.bodyMM, text: nation.toKoreanCountryName(), color: DSKitAsset.Colors.black400.color)
        scheduleLabel.setText(.bodyMM, text: schedule, color: DSKitAsset.Colors.black400.color)
    }
}

private extension PopularInfoCell {
    func setStyle() {
        thumbnailView.do {
            $0.layer.cornerRadius = 6
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .systemGray6
        }
        
        nationalFlagLabel.do {
            $0.font = .systemFont(ofSize: 13.5 * max(1.adjusted, 1.adjustedH))
        }
        
        nationStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4.adjusted
        }
        
        titleLabel.do {
            $0.numberOfLines = 2
        }
        
        dotLabel.do {
            $0.setText(.bodyMM, text: "•", color: DSKitAsset.Colors.black400.color)
        }
        
        infoStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .leading
        }
        
        textContainerStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }
        
        
    }
    
    func setUI() {
        nationStackView.addArrangedSubviews(nationalFlagLabel, nationLabel)
        textContainerStackView.addArrangedSubviews(cityLabel, dotLabel, scheduleLabel)
        infoStackView.addArrangedSubviews(titleLabel, textContainerStackView)
        contentView.addSubviews(thumbnailView, nationStackView, infoStackView)
    }
    
    func setLayout() {
        thumbnailView.snp.makeConstraints {
            $0.width.equalTo(140.adjusted)
            $0.height.equalTo(thumbnailView.snp.width).multipliedBy(88.0 / 140.0)
            $0.leading.top.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        nationStackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(12.adjusted)
            $0.top.equalToSuperview()
        }
        
        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(12.adjusted)
            $0.top.equalTo(nationalFlagLabel.snp.bottom).offset(10.adjustedH)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}
