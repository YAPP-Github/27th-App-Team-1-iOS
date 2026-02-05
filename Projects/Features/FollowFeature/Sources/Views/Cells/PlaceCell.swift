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

    // 순서 뷰 (셀 왼쪽)
    private let sequenceView = UIView().then {
        $0.backgroundColor = UIColor(hexCode: "#28A745")
        $0.layer.cornerRadius = 10
    }

    private let sequenceLabel = UILabel()

    // 메인 컨테이너
    private let containerView = UIView().then {
        $0.backgroundColor = UIColor(hexCode: "#FFFFFF")
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hexCode: "#EEF2FF").cgColor
        $0.clipsToBounds = true
    }

    // 체류 시간
    private let durationLabel = UILabel()

    // 장소명
    private let placeNameLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
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
        [durationLabel, placeNameLabel, thumbnailImageView].forEach {
            containerView.addSubview($0)
        }

        // 이동 시간 정보
        contentView.addSubview(travelTimeContainerView)
        [travelTimeLabel, chevronImageView].forEach {
            travelTimeContainerView.addSubview($0)
        }
    }

    private func setupConstraints() {
        // 메인 컨테이너
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7.5)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(84)
        }

        // 순서 뷰 (왼쪽, centerY를 container에 맞춤)
        sequenceView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(containerView)
            $0.size.equalTo(20)
        }

        sequenceLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        // 컨테이너 leading은 순서뷰 trailing에서 띄움
        containerView.snp.makeConstraints {
            $0.leading.equalTo(sequenceView.snp.trailing).offset(8)
        }

        // 체류 시간
        durationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16.5)
            $0.leading.equalToSuperview().offset(16)
        }

        // 장소명
        placeNameLabel.snp.makeConstraints {
            $0.top.equalTo(durationLabel.snp.bottom).offset(11)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-12)
        }

        // 썸네일
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-16)
            $0.size.equalTo(56)
        }

        // 이동 시간 컨테이너
        travelTimeContainerView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(17.5)
            $0.leading.equalTo(containerView).offset(16)
            $0.trailing.equalTo(containerView).offset(-16)
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

    private func formatTravelTime(place: TravelPlace) -> String {
        var components: [String] = []

        // 시간 정보
        if let transport = place.transportation.first, let timeMin = transport.timeMin {
            components.append("약 \(timeMin)분")
        }

        // 거리 정보
        if let distance = place.distanceKm {
            components.append(String(format: "%.1fkm", distance))
        }

        return components.isEmpty ? "" : components.joined(separator: " • ")
    }

    private func formatDuration(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60

        if hours > 0 && mins > 0 {
            return "\(hours)시간 \(mins)분 체류 예상"
        } else if hours > 0 {
            return "\(hours)시간 체류 예상"
        } else {
            return "\(mins)분 체류 예상"
        }
    }

    func configure(with place: TravelPlace, isLast: Bool = false) {
        // 순서
        sequenceLabel.setText(.bodySSB, text: "\(place.sequence - 1)", color: UIColor(hexCode: "#FFFFFF"))

        // 체류 시간
        if let duration = place.estimatedDuration {
            durationLabel.setText(.bodySR, text: formatDuration(duration), color: UIColor(hexCode: "#757575"))
        } else {
            durationLabel.setText(.bodySR, text: "", color: UIColor(hexCode: "#757575"))
        }

        // 장소명
        placeNameLabel.setText(.bodyLSB, text: place.place.name, color: UIColor(hexCode: "#111111"))

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

        // 이동 시간 정보 (항상 표시, > 버튼도 항상 표시)
        travelTimeContainerView.isHidden = false
        let travelTimeText = formatTravelTime(place: place)
        travelTimeLabel.setText(.bodySR, text: travelTimeText, color: UIColor(hexCode: "#757575"))
    }
}
