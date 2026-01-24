//
//  PlaceCell.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core
import Domain
import DSKit
import Kingfisher
import SnapKit
import Then
import UIKit

final class PlaceCell: UICollectionViewCell {

    static let identifier = "PlaceCell"

    // MARK: - UI Components

    private let containerView = UIView().then {
        $0.backgroundColor = UIColor.NDGL.Bg.primary
    }

    private let durationLabel = UILabel()

    private let sequenceView = UIView().then {
        $0.backgroundColor = UIColor.NDGL.Bg.Interactive.primary
        $0.layer.cornerRadius = 12
    }

    private let sequenceLabel = UILabel()

    private let placeNameLabel = UILabel()

    private let tipLabel = UILabel().then {
        $0.numberOfLines = 2
    }

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = UIColor.NDGL.Bg.Interactive.subtle02
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    private let separatorView = UIView().then {
        $0.backgroundColor = UIColor.NDGL.Border.secondary
    }

    private let timeInfoLabel = UILabel()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.kf.cancelDownloadTask()
        thumbnailImageView.image = nil
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.addSubview(containerView)

        [durationLabel, sequenceView, placeNameLabel, tipLabel, thumbnailImageView, separatorView, timeInfoLabel].forEach {
            containerView.addSubview($0)
        }

        sequenceView.addSubview(sequenceLabel)
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        // 예상 체류 시간
        durationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview()
        }

        // 순서 뷰
        sequenceView.snp.makeConstraints {
            $0.top.equalTo(durationLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.size.equalTo(24)
        }

        sequenceLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        // 장소명
        placeNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(sequenceView)
            $0.leading.equalTo(sequenceView.snp.trailing).offset(8)
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-8)
        }

        // 팁
        tipLabel.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(placeNameLabel)
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-8)
        }

        // 썸네일
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(durationLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(72)
        }

        // 구분선
        separatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }

        // 시간 정보
        timeInfoLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(separatorView.snp.top).offset(-8)
        }
    }

    // MARK: - Configuration

    func configure(with place: TravelPlace, isLast: Bool = false) {
        durationLabel.setText(.bodySR, text: "\(place.estimatedDuration)분 체류 예상", color: UIColor.NDGL.Text.tertiary)
        sequenceLabel.setText(.bodySSB, text: "\(place.sequence)", color: UIColor.NDGL.Text.Interactive.inverse)
        placeNameLabel.setText(.bodyLSB, text: place.place.name, color: UIColor.NDGL.Text.primary)
        tipLabel.setText(.bodySR, text: place.travelerTip, color: UIColor.NDGL.Text.tertiary)
        separatorView.isHidden = isLast

        // 썸네일 이미지 로딩
        if let thumbnailURLString = place.place.thumbnail,
           let thumbnailURL = URL(string: thumbnailURLString) {
            thumbnailImageView.kf.setImage(
                with: thumbnailURL,
                placeholder: nil,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        }

        // 다음 장소까지 이동 시간 (Mock)
        if !isLast {
            timeInfoLabel.setText(.bodySR, text: "약 30분 • 28.8km", color: UIColor.NDGL.Text.tertiary)
        } else {
            timeInfoLabel.setText(.bodySR, text: "", color: UIColor.NDGL.Text.tertiary)
        }
    }
}
