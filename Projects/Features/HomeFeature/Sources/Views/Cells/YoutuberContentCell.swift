//
//  YoutuberContentCell.swift
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

final class YoutuberContentCell: UICollectionViewCell {

    static let identifier = "YoutuberContentCell"

    // MARK: - UI Components

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
    }

    private let infoLabel = UILabel().then {
        $0.numberOfLines = 1
    }

    private let textStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
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
    }

    // MARK: - Setup

    private func setupUI() {
        [thumbnailImageView, textStackView].forEach {
            contentView.addSubview($0)
        }
        [titleLabel, infoLabel].forEach {
            textStackView.addArrangedSubview($0)
        }
    }

    private func setupConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(136)
        }

        textStackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }

    // MARK: - Configuration

    func configure(with trip: PopularTrip) {
        titleLabel.setText(.bodyMSB, text: trip.title, color: UIColor.NDGL.Text.primary)
        infoLabel.setText(.bodySM, text: "\(trip.authorName) · \(trip.destination) · \(trip.duration)", color: UIColor.NDGL.Text.tertiary)

        if let urlString = trip.thumbnailURL, let url = URL(string: urlString) {
            thumbnailImageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
            thumbnailImageView.backgroundColor = .systemGray5
        }
    }
}
