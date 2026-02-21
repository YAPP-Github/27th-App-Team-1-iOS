//
//  TravelToolEmptyView.swift
//  TravelToolFeature
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

final class TravelToolEmptyView: UIView {
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
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

private extension TravelToolEmptyView {
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

        imageView.do {
            $0.image = DSKitAsset.Assets.icEmptyTrip.image
            $0.contentMode = .scaleAspectFit
        }
    }

    func setUI() {
        addSubviews(titleLabel, subTitleLabel, imageView)
    }

    func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17.5.adjustedH)
            $0.leading.equalToSuperview().inset(16.adjusted)
            $0.trailing.lessThanOrEqualTo(imageView.snp.leading)
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6.adjustedH)
            $0.leading.equalToSuperview().inset(16.adjusted)
            $0.trailing.lessThanOrEqualTo(imageView.snp.leading)
            $0.bottom.equalToSuperview().inset(17.5.adjustedH)
        }

        imageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.adjusted)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(76.adjustedH)
        }
    }
}
