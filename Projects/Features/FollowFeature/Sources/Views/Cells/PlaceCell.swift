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
import SnapKit
import Then
import UIKit

final class PlaceCell: UICollectionViewCell {

    static let identifier = "PlaceCell"

    // MARK: - Properties

    var onContainerTapped: (() -> Void)?
    var onDragHandlePan: ((UIPanGestureRecognizer) -> Void)?

    private var isChecked: Bool = false
    private var containerTrailingConstraint: Constraint?

    // MARK: - UI Components

    // 순서 뷰 (셀 왼쪽)
    private let sequenceView = UIView().then {
        $0.backgroundColor = UIColor(hexCode: "#28A745")
        $0.layer.cornerRadius = 10
    }

    private let sequenceLabel = UILabel()

    // 체크박스 (편집 모드)
    private let checkboxView = UIView().then {
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor(hexCode: "#28A745").cgColor
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .clear
        $0.isHidden = true
    }

    private let checkmarkImageView = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }

    // 드래그 핸들 (편집 모드)
    private let dragHandleImageView = UIImageView().then {
        $0.image = UIImage(systemName: "line.3.horizontal")
        $0.tintColor = UIColor(hexCode: "#BDBDBD")
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }

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
        setupGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.kf.cancelDownloadTask()
        thumbnailImageView.image = nil
        travelTimeContainerView.isHidden = false
        onContainerTapped = nil
        onDragHandlePan = nil
        setEditMode(false)
    }

    // MARK: - Gestures

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerViewTapped))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true

        // 체크박스 자체를 눌러도 동일하게 동작
        let checkboxTapGesture = UITapGestureRecognizer(target: self, action: #selector(containerViewTapped))
        checkboxView.addGestureRecognizer(checkboxTapGesture)
        checkboxView.isUserInteractionEnabled = true

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDragHandlePan(_:)))
        dragHandleImageView.addGestureRecognizer(panGesture)
        dragHandleImageView.isUserInteractionEnabled = true
    }

    @objc private func containerViewTapped() {
        onContainerTapped?()
    }

    @objc private func handleDragHandlePan(_ gesture: UIPanGestureRecognizer) {
        onDragHandlePan?(gesture)
    }

    // MARK: - Setup

    private func setupUI() {
        // 순서 뷰
        contentView.addSubview(sequenceView)
        sequenceView.addSubview(sequenceLabel)

        // 체크박스 (편집 모드)
        contentView.addSubview(checkboxView)
        checkboxView.addSubview(checkmarkImageView)

        // 드래그 핸들 (편집 모드)
        contentView.addSubview(dragHandleImageView)

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
        // 순서 뷰 (왼쪽, centerY를 container에 맞춤)
        sequenceView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(containerView)
            $0.size.equalTo(20)
        }

        sequenceLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        // 체크박스 (편집 모드, 순서 뷰와 동일 위치)
        checkboxView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(containerView)
            $0.size.equalTo(20)
        }

        checkmarkImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(12)
        }

        // 드래그 핸들 (편집 모드, 오른쪽)
        dragHandleImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(containerView)
            $0.size.equalTo(20)
        }

        // 메인 컨테이너
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7.5)
            $0.leading.equalTo(sequenceView.snp.trailing).offset(8)
            containerTrailingConstraint = $0.trailing.equalToSuperview().constraint
            $0.height.equalTo(84)
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

    // MARK: - Edit Mode

    func setEditMode(_ isEditing: Bool, isChecked: Bool = false) {
        sequenceView.isHidden = isEditing
        checkboxView.isHidden = !isEditing
        dragHandleImageView.isHidden = !isEditing

        if isEditing {
            containerTrailingConstraint?.update(inset: 28)
        } else {
            containerTrailingConstraint?.update(inset: 0)
        }

        self.isChecked = isChecked
        updateCheckboxAppearance()
        setNeedsLayout()
    }

    private func updateCheckboxAppearance() {
        if isChecked {
            checkboxView.backgroundColor = UIColor(hexCode: "#28A745")
            checkmarkImageView.isHidden = false
        } else {
            checkboxView.backgroundColor = .clear
            checkmarkImageView.isHidden = true
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
        sequenceLabel.setText(.bodySSB, text: "\(place.sequence)", color: UIColor(hexCode: "#FFFFFF"))

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
