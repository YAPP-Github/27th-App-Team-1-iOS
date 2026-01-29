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
import Kingfisher
import SnapKit
import Then

final class RecommendContentCell: UICollectionViewCell {

    static let identifier = "RecommendContentCell"

    // MARK: - Properties

    private var currentThumbnailURL: String?

    // MARK: - UI Components

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

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
        $0.tintColor = UIColor(hexCode: "#444444")
        $0.contentMode = .scaleAspectFit
    }

    private let authorLabel = UILabel()

    private let durationLabel = UILabel()

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
        currentThumbnailURL = nil
        thumbnailImageView.kf.cancelDownloadTask()
        thumbnailImageView.image = nil
        thumbnailImageView.backgroundColor = .systemGray5
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.addSubview(thumbnailImageView)
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

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }

        authorInfoView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }

        playIcon.snp.makeConstraints {
            $0.size.equalTo(14)
        }
    }

    // MARK: - Configuration

    func configure(with recommendation: Recommendation) {
        titleLabel.setText(.bodyMSB, text: recommendation.title, color: UIColor(hexCode: "#111111"))
        authorLabel.setText(.bodySR, text: recommendation.authorName, color: UIColor(hexCode: "#444444"))
        durationLabel.setText(.bodySR, text: " · \(recommendation.duration)", color: UIColor(hexCode: "#444444"))

        // URL 저장 및 이미지 로딩 (교차 검증)
        let thumbnailURL = recommendation.thumbnailURL
        currentThumbnailURL = thumbnailURL

        if let urlString = thumbnailURL, let url = URL(string: urlString) {
            thumbnailImageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            ) { [weak self] result in
                guard let self = self else { return }
                guard self.currentThumbnailURL == urlString else { return }

                switch result {
                case .success:
                    break
                case .failure:
                    self.thumbnailImageView.backgroundColor = .systemGray5
                }
            }
        } else {
            thumbnailImageView.backgroundColor = .systemGray5
        }
    }
}
