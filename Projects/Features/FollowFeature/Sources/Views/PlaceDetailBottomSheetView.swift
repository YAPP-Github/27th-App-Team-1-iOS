//
//  PlaceDetailBottomSheetView.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core
import Domain
import DSKit
import SnapKit
import Then
import UIKit

final class PlaceDetailBottomSheetView: UIView {

    // MARK: - UI Components

    // 상단 타이틀 영역
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
    }

    private let chevronButton = UIButton(type: .system).then {
        $0.setImage(DSKitAsset.Assets.icChevronRight3.image, for: .normal)
        $0.tintColor = UIColor(hexCode: "#111111")
    }

    // 카테고리 + 체류시간
    private let categoryInfoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }

    private let categoryLabel = UILabel()

    private let dotLabel = UILabel()

    private let durationLabel = UILabel()

    private let categoryChevronImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icChevronRight3.image
        $0.tintColor = UIColor(hexCode: "#757575")
        $0.contentMode = .scaleAspectFit
    }

    // 영업시간
    private let openingHoursLabel = UILabel()

    // 시간 추가
    private let timeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }

    private let timeIconImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icClock1.image
        $0.tintColor = UIColor(hexCode: "#2C2C2C")
        $0.contentMode = .scaleAspectFit
    }

    private let timeLabel = UILabel()

    // 비용 추가
    private let costStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }

    private let costIconImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icCard1.image
        $0.tintColor = UIColor(hexCode: "#2C2C2C")
        $0.contentMode = .scaleAspectFit
    }

    private let costLabel = UILabel()

    // 길찾기 버튼
    private let findRouteButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor(hexCode: "#FFFFFF")
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hexCode: "#D9D9D9").cgColor
    }

    private let findRouteStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
        $0.isUserInteractionEnabled = false
    }

    private let findRouteLabel = UILabel()

    private let findRouteIconImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icMap1.image
        $0.tintColor = UIColor(hexCode: "#111111")
        $0.contentMode = .scaleAspectFit
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

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .white

        [titleLabel, chevronButton, categoryInfoStackView, openingHoursLabel,
         timeStackView, costStackView, findRouteButton].forEach {
            addSubview($0)
        }

        // 카테고리 스택뷰
        [categoryLabel, dotLabel, durationLabel, categoryChevronImageView].forEach {
            categoryInfoStackView.addArrangedSubview($0)
        }

        // 시간 스택뷰
        [timeIconImageView, timeLabel].forEach {
            timeStackView.addArrangedSubview($0)
        }

        // 비용 스택뷰
        [costIconImageView, costLabel].forEach {
            costStackView.addArrangedSubview($0)
        }

        // 길찾기 버튼 내부
        findRouteButton.addSubview(findRouteStackView)
        [findRouteLabel, findRouteIconImageView].forEach {
            findRouteStackView.addArrangedSubview($0)
        }

        // 기본 텍스트 설정
        dotLabel.setText(.bodySR, text: "•", color: UIColor(hexCode: "#444444"))
        findRouteLabel.setText(.bodyMSB, text: "길찾기", color: UIColor(hexCode: "#111111"))
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(chevronButton.snp.leading).offset(-8)
        }

        chevronButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().offset(-24)
            $0.size.equalTo(24)
        }

        categoryInfoStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
        }

        categoryChevronImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }

        openingHoursLabel.snp.makeConstraints {
            $0.top.equalTo(categoryInfoStackView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(24)
        }

        timeIconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }

        timeStackView.snp.makeConstraints {
            $0.top.equalTo(openingHoursLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
        }

        costIconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }

        costStackView.snp.makeConstraints {
            $0.top.equalTo(timeStackView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
        }

        findRouteButton.snp.makeConstraints {
            $0.top.equalTo(costStackView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().offset(-16)
        }

        findRouteStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        findRouteIconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
    }

    // MARK: - Configuration

    func configure(with place: TravelPlace) {
        // 타이틀
        titleLabel.setText(.subTitleLSB, text: place.place.name, color: UIColor(hexCode: "#111111"))

        // 카테고리 (기본값: 관광명소)
        categoryLabel.setText(.bodySR, text: "🏔 관광명소", color: UIColor(hexCode: "#757575"))

        // 체류 예상 시간
        let durationText: String
        if let duration = place.estimatedDuration {
            let hours = duration / 60
            let minutes = duration % 60
            if hours > 0 && minutes > 0 {
                durationText = "\(hours)시간 \(minutes)분 체류 예상"
            } else if hours > 0 {
                durationText = "\(hours)시간 체류 예상"
            } else {
                durationText = "\(minutes)분 체류 예상"
            }
        } else {
            durationText = ""
        }
        durationLabel.setText(.bodySR, text: durationText, color: UIColor(hexCode: "#444444"))

        // 영업시간
        let openingHours = place.place.regularOpeningHours ?? "-"
        openingHoursLabel.setText(.bodySR, text: "영업시간 \(openingHours)", color: UIColor(hexCode: "#2C2C2C"))

        // 시간 추가 (기본값)
        timeLabel.setText(.bodySR, text: "시간 추가", color: UIColor(hexCode: "#444444"))

        // 비용 추가 (기본값)
        costLabel.setText(.bodySR, text: "비용 추가", color: UIColor(hexCode: "#444444"))
    }
}
