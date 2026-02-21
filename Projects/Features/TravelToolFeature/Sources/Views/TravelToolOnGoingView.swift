//
//  TravelToolOnGoingView.swift
//  TravelToolFeature
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

final class TravelToolOnGoingView: UIView {
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let durationLabel = UILabel()
    private let placeLabel = UILabel()
    private let imageView = UIImageView()
    private let routeCardView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        title: String,
        date: String,
        duration: String,
        place: String,
        imageUrl: String
    ) {
        titleLabel.setText(.subTitleMSB, text: title, color: DSKitAsset.Colors.black700.color)
        dateLabel.setText(.bodyMR, text: date, color: DSKitAsset.Colors.black500.color)
        durationLabel.setText(.bodySM, text: "\(duration) 체류 예상", color: DSKitAsset.Colors.black400.color)
        placeLabel.setText(.bodyLSB, text: place, color: DSKitAsset.Colors.black900.color)

        if let url = URL(string: imageUrl) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.backgroundColor = .systemGray5
        }
    }
}

private extension TravelToolOnGoingView {
    func setStyle() {
        backgroundColor = .clear

        imageView.do {
            $0.layer.cornerRadius = 4.adjustedH
            $0.backgroundColor = .systemGray6
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }

        routeCardView.do {
            $0.backgroundColor = DSKitAsset.Colors.white.color
            $0.layer.cornerRadius = 16.adjustedH
            $0.clipsToBounds = true
        }
    }

    func setUI() {
        routeCardView.addSubviews(durationLabel, placeLabel, imageView)
        addSubviews(titleLabel, dateLabel, routeCardView)
    }

    func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16.adjusted)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4.adjustedH)
            $0.leading.equalToSuperview().inset(16.adjusted)
        }

        routeCardView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(16.adjustedH)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16.adjusted)
            $0.height.equalTo(84.adjustedH)
            $0.bottom.equalToSuperview().inset(23.adjustedH).priority(.low)
        }

        durationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.5.adjustedH)
            $0.leading.equalToSuperview().inset(16.adjusted)
        }

        placeLabel.snp.makeConstraints {
            $0.top.equalTo(durationLabel.snp.bottom).offset(10.adjustedH)
            $0.leading.equalToSuperview().inset(16.adjusted)
            $0.trailing.lessThanOrEqualTo(imageView.snp.leading).offset(-8.adjusted)
        }

        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.adjustedH)
            $0.trailing.bottom.equalToSuperview().inset(16.adjusted)
            $0.width.equalTo(imageView.snp.height)
        }
    }
}
