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
import Kingfisher
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

    // MARK: - UI Components (항상 보이는 영역)

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = UIColor.NDGL.Bg.disabled
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }

    private let youtuberNameLabel = UILabel()

    private let locationLabel = UILabel()

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
    }

    private let toggleButton = UIButton(type: .system).then {
        $0.setImage(DSKitAsset.Assets.icChevronDown1.image, for: .normal)
        $0.tintColor = UIColor.NDGL.Icon.tertiary
    }

    // MARK: - UI Components (펼쳤을 때만 보이는 영역)

    private let expandedContainerView = UIView().then {
        $0.isHidden = true
        $0.clipsToBounds = true
    }

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = UIColor.NDGL.Bg.Interactive.subtle02
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    private let budgetTitleLabel = UILabel()

    private let budgetValueLabel = UILabel()

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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = UIColor.NDGL.Bg.Interactive.subtle02

        [profileImageView, youtuberNameLabel, locationLabel, titleLabel, toggleButton, expandedContainerView].forEach {
            addSubview($0)
        }

        [thumbnailImageView, budgetTitleLabel, budgetValueLabel, summaryTitleLabel, summaryLabel].forEach {
            expandedContainerView.addSubview($0)
        }

        // 타이포그래피 설정
        budgetTitleLabel.setText(.bodyMM, text: "1인 기준 전체 예산 :", color: UIColor.NDGL.Text.secondary)
        summaryTitleLabel.setText(.bodyMSB, text: "영상 요약", color: UIColor.NDGL.Text.primary)
    }

    private func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(40)
        }

        youtuberNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }

        locationLabel.snp.makeConstraints {
            $0.top.equalTo(youtuberNameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(youtuberNameLabel)
        }

        toggleButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.size.equalTo(44)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(toggleButton.snp.leading).offset(-8)
        }

        // expandedContainerView는 top만 연결, bottom은 연결하지 않음
        expandedContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }

        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(180)
        }

        budgetTitleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }

        budgetValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(budgetTitleLabel)
            $0.leading.equalTo(budgetTitleLabel.snp.trailing).offset(4)
        }

        summaryTitleLabel.snp.makeConstraints {
            $0.top.equalTo(budgetTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }

        summaryLabel.snp.makeConstraints {
            $0.top.equalTo(summaryTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
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
        let image = isExpanded ? DSKitAsset.Assets.icChevronUp1.image : DSKitAsset.Assets.icChevronDown1.image
        toggleButton.setImage(image, for: .normal)
    }

    // MARK: - Configuration

    func configure(with detail: TravelDetail) {
        youtuberNameLabel.setText(.bodySM, text: detail.youtube.youtuber, color: UIColor.NDGL.Text.secondary)
        locationLabel.setText(
            .bodySR,
            text: "\(detail.country) · \(detail.nights)박\(detail.days)일",
            color: UIColor.NDGL.Text.tertiary
        )
        titleLabel.setText(.bodyLSB, text: detail.youtube.title, color: UIColor.NDGL.Text.primary)
        budgetValueLabel.setText(
            .bodyMSB,
            text: formatBudget(detail.budgetPerPerson),
            color: UIColor.NDGL.Text.primary
        )
        summaryLabel.setText(.bodyMR, text: detail.youtube.summary, color: UIColor.NDGL.Text.secondary)

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

    func getCollapsedHeight() -> CGFloat {
        120
    }

    func getExpandedHeight() -> CGFloat {
        450
    }
}
