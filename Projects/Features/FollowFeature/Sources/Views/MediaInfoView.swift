//
//  MediaInfoView.swift
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

protocol MediaInfoViewDelegate: AnyObject {
    func mediaInfoViewDidToggleExpand(_ view: MediaInfoView, isExpanded: Bool)
}

final class MediaInfoView: UIView {

    // MARK: - Properties

    weak var delegate: MediaInfoViewDelegate?
    private var isExpanded: Bool = false

    // 동적 높이를 위한 bottom constraint
    private var collapsedBottomConstraint: Constraint?
    private var expandedBottomConstraint: Constraint?

    // MARK: - UI Components (항상 보이는 영역)

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = UIColor(hexCode: "#B3B3B3")
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
    }

    private let travelInfoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }

    private let travelInfoIconView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icVideo1.image.withRenderingMode(.alwaysTemplate)
        $0.tintColor = DSKitAsset.Colors.black400.color
        $0.contentMode = .scaleAspectFit
    }

    private let travelInfoLabel = UILabel()

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }

    private let toggleButton = UIButton(type: .system).then {
        $0.setImage(DSKitAsset.Assets.icChevronDown3.image, for: .normal)
        $0.tintColor = UIColor(hexCode: "#757575")
    }

    // MARK: - UI Components (펼쳤을 때만 보이는 영역)

    private let expandedContainerView = UIView().then {
        $0.isHidden = true
        $0.clipsToBounds = true
    }

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = UIColor(hexCode: "#F5F5F5")
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    // 예산 정보 (icPiggybank1 + 8px + "1인 기준 예산 얼마")
    private let budgetStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }

    private let budgetIconView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icPiggybank1.image.withRenderingMode(.alwaysTemplate)
        $0.tintColor = UIColor(hexCode: "#2960EC")
        $0.contentMode = .scaleAspectFit
    }

    private let budgetLabel = UILabel()

    private let separatorView = UIView().then {
        $0.backgroundColor = UIColor(hexCode: "#D9D9D9")
    }

    // 영상 요약 타이틀 (icBook1 + 8px + "영상 요약")
    private let summaryTitleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }

    private let summaryIconView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icMagic1.image
        $0.contentMode = .scaleAspectFit
    }

    private let summaryTitleLabel = UILabel()

    private let summaryLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        setupUI()
        setupConstraints()
        setupActions()
        layer.cornerRadius = 20
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupActions() {
        toggleButton.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func toggleButtonTapped() {
        isExpanded.toggle()
        updateExpandedState()
        delegate?.mediaInfoViewDidToggleExpand(self, isExpanded: isExpanded)
    }

    private func updateExpandedState() {
        expandedContainerView.isHidden = !isExpanded
        let image = isExpanded ? DSKitAsset.Assets.icChevronUp3.image : DSKitAsset.Assets.icChevronDown3.image
        toggleButton.setImage(image, for: .normal)

        // 타이틀 줄 수 토글 (collapsed: 1줄, expanded: 무제한)
        titleLabel.numberOfLines = isExpanded ? 0 : 1

        // Bottom constraint 토글
        if isExpanded {
            collapsedBottomConstraint?.deactivate()
            expandedBottomConstraint?.activate()
        } else {
            expandedBottomConstraint?.deactivate()
            collapsedBottomConstraint?.activate()
        }
    }

    // MARK: - Configuration

    func configure(with detail: TravelDetail) {
        // 여행 정보 라벨 (유튜버 · 국가 · 3박4일)
        let travelInfoText = "\(detail.youtube.youtuber) · \(detail.country) · \(detail.nights)박\(detail.days)일"
        travelInfoLabel.setText(.bodyMSB, text: travelInfoText, color: UIColor(hexCode: "#757575"))

        // 제목
        titleLabel.setText(.subTitleLSB, text: detail.youtube.title, color: UIColor(hexCode: "#111111"))

        // 예산 라벨 (1인 기준 예산 + 금액) - 파란색
        let budgetText = "1인 기준 예산 \(formatBudget(detail.budgetPerPerson))"
        budgetLabel.setText(.bodyMM, text: budgetText, color: UIColor(hexCode: "#2960EC"))

        // 요약 라벨
        summaryLabel.setText(.bodyMR, text: detail.youtube.summary, color: DSKitAsset.Colors.black400.color)

        // 프로필 이미지 로딩
        if let profileURLString = detail.youtube.profileImage,
           let profileURL = URL(string: profileURLString) {
            profileImageView.kf.setImage(
                with: profileURL,
                placeholder: nil,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        }

        // 썸네일 이미지 로딩
        if let thumbnailURLString = detail.youtube.thumbnail,
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
    }

    private func formatBudget(_ budget: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedNumber = formatter.string(from: NSNumber(value: budget)) ?? "\(budget)"
        return "\(formattedNumber)원"
    }

    // MARK: - Public Methods

    func calculateHeight() -> CGFloat {
        setNeedsLayout()
        layoutIfNeeded()
        let targetSize = CGSize(width: bounds.width, height: UIView.layoutFittingCompressedSize.height)
        return systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
    }
}

extension MediaInfoView {

    private func setupUI() {
        backgroundColor = UIColor(hexCode: "#F5F5F5")

        // 여행 정보 스택뷰 구성
        [travelInfoIconView, travelInfoLabel].forEach {
            travelInfoStackView.addArrangedSubview($0)
        }

        // 예산 스택뷰 구성
        [budgetIconView, budgetLabel].forEach {
            budgetStackView.addArrangedSubview($0)
        }

        // 요약 타이틀 스택뷰 구성
        [summaryIconView, summaryTitleLabel].forEach {
            summaryTitleStackView.addArrangedSubview($0)
        }

        [profileImageView, travelInfoStackView, titleLabel, toggleButton, expandedContainerView].forEach {
            addSubview($0)
        }

        [thumbnailImageView, budgetStackView, separatorView, summaryTitleStackView, summaryLabel].forEach {
            expandedContainerView.addSubview($0)
        }

        // 타이포그래피 설정
        summaryTitleLabel.setText(.bodyMSB, text: "영상 요약", color: UIColor(hexCode: "#111111"))
    }

    private func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.size.equalTo(56)
        }

        travelInfoIconView.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        travelInfoStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(travelInfoStackView.snp.bottom).offset(4)
            $0.leading.equalTo(travelInfoStackView)
            $0.trailing.equalTo(toggleButton.snp.leading).offset(-8)
            // collapsed 상태의 bottom constraint (titleLabel 기준)
            collapsedBottomConstraint = $0.bottom.equalToSuperview().offset(-16).constraint
        }

        toggleButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.trailing.equalToSuperview().offset(-24)
            $0.size.equalTo(28)
        }

        expandedContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            // expanded 상태의 bottom constraint
            expandedBottomConstraint = $0.bottom.equalToSuperview().offset(-16).constraint
        }
        // 초기 상태: collapsed
        expandedBottomConstraint?.deactivate()

        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            // 327:150 비율 유지
            $0.height.equalTo(thumbnailImageView.snp.width).multipliedBy(150.0 / 327.0)
        }

        budgetIconView.snp.makeConstraints {
            $0.size.equalTo(20)
        }

        budgetStackView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(12)
        }

        separatorView.snp.makeConstraints {
            $0.top.equalTo(budgetStackView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(1)
        }

        summaryIconView.snp.makeConstraints {
            $0.size.equalTo(20)
        }

        summaryTitleStackView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(10)
            $0.leading.equalTo(separatorView)
        }

        summaryLabel.snp.makeConstraints {
            $0.top.equalTo(summaryTitleStackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(separatorView)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
