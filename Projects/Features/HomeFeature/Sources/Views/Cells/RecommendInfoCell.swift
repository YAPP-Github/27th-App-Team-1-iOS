//
//  RecommendInfoCell.swift
//  HomeFeature
//
//  Created by 최안용 on 1/31/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

final class RecommendInfoCell: UICollectionViewCell {
    static let defaultWidth = 240.adjusted
    static let defaultHeight = 253.adjustedH
    
    // MARK: - UI Components
    private let thumbnailView = UIImageView()
    private let nationalFlagLabel = UILabel()
    private let nationLabel = UILabel()
    private let titleLabel = UILabel()
    private let firstDotLabel = UILabel()
    private let secondDotLabel = UILabel()
    private let nameLabel = UILabel()
    private let scheduleLabel = UILabel()
    private let cityLabel = UILabel()
    
    private let nationStackView = UIStackView()
    private let subInfoStackView = UIStackView()
    private let infoStackView = UIStackView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        nameLabel.text = nil
        titleLabel.text = nil
        nationLabel.text = nil
        scheduleLabel.text = nil
    }
    
    // MARK: - Configure
    func configure(_ model: HomePresentationModel.RecommendedTrip) {
        if let url = URL(string: model.thumbnailUrl) {
            thumbnailView.kf.setImage(with: url, options: [.transition(.fade(0.3))])
        }
        nationalFlagLabel.text = model.country.toFlag()
        nationLabel.setText(.bodyMM, text: model.country.toKoreanCountryName(), color: DSKitAsset.Colors.black400.color)
        titleLabel.setText(.bodyLSB, text: model.title, color: DSKitAsset.Colors.black700.color)
        nameLabel.setText(.bodyMM, text: model.creator, color: DSKitAsset.Colors.black400.color)
        cityLabel.setText(.bodyMM, text: model.city, color: DSKitAsset.Colors.black400.color)
        scheduleLabel.setText(.bodyMM, text: model.schedule, color: DSKitAsset.Colors.black400.color)
    }
}

private extension RecommendInfoCell {
    func setStyle() {
        thumbnailView.do {
            $0.layer.cornerRadius = 8
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .systemGray6
        }
        
        nationalFlagLabel.do {
            $0.font = .systemFont(ofSize: 10.5 * max(1.adjusted, 1.adjustedH))
        }
        
        titleLabel.do {
            $0.numberOfLines = 2
            $0.lineBreakMode = .byTruncatingTail
        }
        
        firstDotLabel.do {
            $0.setText(.bodyMM, text: "•", color: DSKitAsset.Colors.black400.color)
        }
        
        secondDotLabel.do {
            $0.setText(.bodyMM, text: "•", color: DSKitAsset.Colors.black400.color)
        }
        
        nationStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }
        
        subInfoStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }
        
        infoStackView.do {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.spacing = 4
        }
    }
    
    func setUI() {
        contentView.addSubviews(thumbnailView, nationStackView, infoStackView)
        
        nationStackView.addArrangedSubviews(nationalFlagLabel, nationLabel)
        
        subInfoStackView.addArrangedSubviews(
            nameLabel,
            firstDotLabel,
            cityLabel,
            secondDotLabel,
            scheduleLabel
        )
        infoStackView.addArrangedSubviews(titleLabel, subInfoStackView)
    }
    
    func setLayout() {
        thumbnailView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(thumbnailView.snp.width).multipliedBy(140.0 / 240.0)
        }
        
        nationStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(thumbnailView.snp.bottom).offset(16.adjustedH)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(nationStackView.snp.bottom).offset(10.adjustedH)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().inset(18.adjustedH)
        }
    }
}
