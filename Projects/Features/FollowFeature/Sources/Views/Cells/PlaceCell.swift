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

    // 순서 뷰 (셀 바깥 왼쪽)
    private let sequenceView = UIView().then {
        $0.backgroundColor = UIColor(hexCode: "#28A745")
        $0.layer.cornerRadius = 12
    }

    private let sequenceLabel = UILabel()

    // 메인 컨테이너 (보더 있는 영역)
    private let containerView = UIView().then {
        $0.backgroundColor = UIColor(hexCode: "#FFFFFF")
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hexCode: "#F5F5F5").cgColor
        $0.clipsToBounds = true
    }

    // 카테고리 태그
    private let categoryTagView = UIView().then {
        $0.backgroundColor = UIColor(hexCode: "#F5F5F5")
        $0.layer.cornerRadius = 4
    }

    private let categoryLabel = UILabel()

    // 체류 시간
    private let durationLabel = UILabel()

    // 장소명
    private let placeNameLabel = UILabel().then {
        $0.numberOfLines = 1
    }

    // 팁/설명
    private let tipLabel = UILabel().then {
        $0.numberOfLines = 2
    }

    // 썸네일
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = UIColor(hexCode: "#F5F5F5")
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    // 이동 시간 정보 (컨테이너 아래)
    private let travelTimeContainerView = UIView()

    private let travelTimeLabel = UILabel()

    private let chevronImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icChevronRight3.image
        $0.contentMode = .scaleAspectFit
        $0.tintColor = UIColor(hexCode: "#757575")
    }

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
        travelTimeContainerView.isHidden = false
    }

    // MARK: - Setup

    private func setupUI() {
        // 순서 뷰
        contentView.addSubview(sequenceView)
        sequenceView.addSubview(sequenceLabel)

        // 메인 컨테이너
        contentView.addSubview(containerView)

        // 컨테이너 내부 요소들
        [categoryTagView, durationLabel, placeNameLabel, tipLabel, thumbnailImageView].forEach {
            containerView.addSubview($0)
        }

        categoryTagView.addSubview(categoryLabel)

        // 이동 시간 정보
        contentView.addSubview(travelTimeContainerView)
        [travelTimeLabel, chevronImageView].forEach {
            travelTimeContainerView.addSubview($0)
        }
    }

    private func setupConstraints() {
        // 순서 뷰 (왼쪽 바깥)
        sequenceView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview()
            $0.size.equalTo(24)
        }

        sequenceLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        // 메인 컨테이너
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(sequenceView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(99)
        }

        // 카테고리 태그
        categoryTagView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(12)
            $0.height.equalTo(20)
        }

        categoryLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6))
        }

        // 체류 시간
        durationLabel.snp.makeConstraints {
            $0.centerY.equalTo(categoryTagView)
            $0.leading.equalTo(categoryTagView.snp.trailing).offset(8)
        }

        // 장소명
        placeNameLabel.snp.makeConstraints {
            $0.top.equalTo(categoryTagView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-12)
        }

        // 팁
        tipLabel.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(placeNameLabel)
            $0.trailing.equalTo(placeNameLabel)
        }

        // 썸네일
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.size.equalTo(56)
        }

        // 이동 시간 컨테이너
        travelTimeContainerView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(8)
            $0.leading.equalTo(containerView).offset(12)
            $0.trailing.equalTo(containerView).offset(-12)
            $0.height.equalTo(20)
        }

        travelTimeLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }

        chevronImageView.snp.makeConstraints {
            $0.leading.equalTo(travelTimeLabel.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }
    }

    // MARK: - Configuration

    func configure(with place: TravelPlace, isLast: Bool = false) {
        sequenceLabel.setText(.bodySSB, text: "\(place.sequence)", color: UIColor(hexCode: "#FFFFFF"))

        // 카테고리 (기본값: 교통수단)
        categoryLabel.setText(.bodySR, text: "교통수단", color: UIColor(hexCode: "#2C2C2C"))

        // 체류 시간
        durationLabel.setText(.bodySR, text: "\(place.estimatedDuration)분 체류 예상", color: UIColor(hexCode: "#444444"))

        // 장소명
        placeNameLabel.setText(.bodyLSB, text: place.place.name, color: UIColor(hexCode: "#111111"))

        // 팁
        tipLabel.setText(.bodySR, text: place.travelerTip, color: UIColor(hexCode: "#444444"))

        // 썸네일 이미지 로딩
        if let thumbnailURLString = place.place.thumbnail,
           let thumbnailURL = URL(string: thumbnailURLString) {
            thumbnailImageView.isHidden = false
            thumbnailImageView.kf.setImage(
                with: thumbnailURL,
                placeholder: nil,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
            thumbnailImageView.isHidden = true
        }

        // 이동 시간 정보 (마지막 아이템이면 숨김)
        if isLast {
            travelTimeContainerView.isHidden = true
        } else {
            travelTimeContainerView.isHidden = false
            // TODO: 실제 이동 시간 데이터로 교체
            travelTimeLabel.setText(.bodySR, text: "약 30분 • 28.8km", color: UIColor(hexCode: "#444444"))
        }
    }
}
