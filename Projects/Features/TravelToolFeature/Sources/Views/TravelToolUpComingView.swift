//
//  TravelToolUpComingView.swift
//  TravelToolFeature
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

final class TravelToolUpComingView: UIView {
    private let imageView = UIImageView()
    private let badge = UIView()
    private let dDayLabel = UILabel()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, date: String, dDay: Int, imageUrl: String) {
        titleLabel.setText(.subTitleMSB, text: title, color: DSKitAsset.Colors.black700.color)
        dateLabel.setText(.bodyMR, text: date, color: DSKitAsset.Colors.black600.color)
        dDayLabel.setText(.bodyMM, text: "D-\(dDay)", color: DSKitAsset.Colors.black400.color)

        if let url = URL(string: imageUrl) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.backgroundColor = .systemGray5
        }
    }
}

private extension TravelToolUpComingView {
    func setStyle() {
        backgroundColor = .clear

        imageView.do {
            $0.layer.cornerRadius = 64.adjustedH / 2
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }

        badge.do {
            $0.backgroundColor = DSKitAsset.Colors.black100.color
            $0.layer.cornerRadius = 26.adjustedH / 2
            $0.clipsToBounds = true
        }

        titleLabel.do {
            $0.numberOfLines = 1
        }
    }

    func setUI() {
        badge.addSubview(dDayLabel)
        addSubviews(imageView, badge, titleLabel, dateLabel)
    }

    func setLayout() {
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.adjusted)
            $0.top.bottom.equalToSuperview().inset(8.adjustedH)
            $0.size.equalTo(64.adjustedH)
        }

        badge.snp.makeConstraints {
            $0.top.equalTo(imageView).offset(7.adjustedH)
            $0.leading.equalTo(imageView.snp.trailing).offset(12.adjusted)
            $0.height.equalTo(26.adjustedH)
        }

        dDayLabel.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(12.adjusted)
            $0.directionalVerticalEdges.equalToSuperview().inset(4.adjustedH)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(badge.snp.trailing).offset(8.adjusted)
            $0.centerY.equalTo(badge)
            $0.trailing.lessThanOrEqualToSuperview().inset(16.adjusted)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(badge.snp.bottom).offset(8.adjustedH)
            $0.leading.equalTo(badge)
        }
    }
}
