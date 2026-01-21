//
//  RecommendationCell.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import UIKit

import SnapKit
import Then

final class RecommendationCell: UICollectionViewCell {

    static let identifier = "RecommendationCell"

    // MARK: - UI Components

    private let containerView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray4
        $0.clipsToBounds = true
    }

    private let gradientView = UIView()

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .white
        $0.numberOfLines = 2
    }

    private let authorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white.withAlphaComponent(0.8)
        $0.numberOfLines = 1
    }

    private let infoLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11)
        $0.textColor = .white.withAlphaComponent(0.7)
        $0.numberOfLines = 1
    }

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
        contentView.addSubview(containerView)
        [thumbnailImageView, gradientView, titleLabel, authorLabel, infoLabel].forEach {
            containerView.addSubview($0)
        }
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        gradientView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }

        infoLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().offset(-12)
        }

        authorLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalTo(infoLabel.snp.top).offset(-4)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalTo(authorLabel.snp.top).offset(-4)
        }
    }

    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
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
        titleLabel.text = recommendation.title
        authorLabel.text = recommendation.authorName
        infoLabel.text = "\(recommendation.destination) | \(recommendation.duration)"

        // TODO: 이미지 로딩 구현
        thumbnailImageView.backgroundColor = .systemGray4
    }
}
