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
import SnapKit
import Then

final class YoutuberContentCell: UICollectionViewCell {

    static let identifier = "YoutuberContentCell"

    // MARK: - UI Components

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray4
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    private let flagImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel()

    private let infoLabel = UILabel()

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

    // MARK: - Setup

    private func setupUI() {
        [thumbnailImageView, flagImageView, textStackView].forEach {
            contentView.addSubview($0)
        }
        [titleLabel, infoLabel].forEach {
            textStackView.addArrangedSubview($0)
        }
    }

    private func setupConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(120)
        }

        flagImageView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            $0.top.equalToSuperview().offset(8)
            $0.size.equalTo(20)
        }

        textStackView.snp.makeConstraints {
            $0.leading.equalTo(flagImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(flagImageView)
        }
    }

    // MARK: - Configuration

    func configure(with trip: PopularTrip) {
        titleLabel.setText(.bodyMSB, text: trip.title, color: UIColor.NDGL.Text.primary)
        infoLabel.setText(.bodySM, text: "\(trip.destination) · \(trip.duration)", color: UIColor.NDGL.Text.tertiary)

        // 국기 이미지 설정 (임시)
        flagImageView.image = UIImage(systemName: "flag.fill")
        flagImageView.tintColor = .systemBlue

        // TODO: 실제 이미지 로딩
        thumbnailImageView.backgroundColor = .systemGray4
    }
}
