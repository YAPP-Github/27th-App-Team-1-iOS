//
//  RecommendContentCell.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import UIKit
import DSKit
import SnapKit
import Then

final class RecommendContentCell: UICollectionViewCell {

    static let identifier = "RecommendContentCell"

    // MARK: - UI Components

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray4
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    private let gradientView = UIView()

    private let countryTagView = UIView().then {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        $0.layer.cornerRadius = 12
    }

    private let flagImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let countryLabel = UILabel()

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
    }

    private let authorInfoView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }

    private let playIcon = UIImageView().then {
        $0.image = UIImage(systemName: "play.rectangle.fill")
        $0.tintColor = UIColor.NDGL.Text.tertiary
        $0.contentMode = .scaleAspectFit
    }

    private let authorLabel = UILabel()

    private let durationLabel = UILabel()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupGradient()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.addSubview(gradientView)

        contentView.addSubview(countryTagView)
        countryTagView.addSubview(flagImageView)
        countryTagView.addSubview(countryLabel)

        contentView.addSubview(titleLabel)
        contentView.addSubview(authorInfoView)

        [playIcon, authorLabel, durationLabel].forEach {
            authorInfoView.addArrangedSubview($0)
        }
    }

    private func setupConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(180)
        }

        gradientView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(60)
        }

        countryTagView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalTo(thumbnailImageView.snp.bottom).offset(-8)
            $0.height.equalTo(24)
        }

        flagImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }

        countryLabel.snp.makeConstraints {
            $0.leading.equalTo(flagImageView.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }

        authorInfoView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }

        playIcon.snp.makeConstraints {
            $0.size.equalTo(14)
        }
    }

    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.3).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func updateGradientFrame() {
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = gradientView.bounds
        }
    }

    // MARK: - Configuration

    func configure(with recommendation: Recommendation) {
        titleLabel.setText(.bodyMSB, text: recommendation.title, color: UIColor.NDGL.Text.primary)
        countryLabel.setText(.bodySR, text: recommendation.destination, color: UIColor.NDGL.Text.primary)
        authorLabel.setText(.bodySR, text: recommendation.authorName, color: UIColor.NDGL.Text.tertiary)
        durationLabel.setText(.bodySR, text: " · \(recommendation.duration)", color: UIColor.NDGL.Text.tertiary)

        // 국기 이미지 설정 (임시)
        flagImageView.image = UIImage(systemName: "flag.fill")
        flagImageView.tintColor = .systemOrange

        // TODO: 실제 이미지 로딩
        thumbnailImageView.backgroundColor = .systemGray4
    }
}
