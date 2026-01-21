//
//  PopularTripCell.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import UIKit

import SnapKit
import Then

final class PopularTripCell: UICollectionViewCell {

    static let identifier = "PopularTripCell"

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

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .black
        $0.numberOfLines = 2
    }

    private let authorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .systemGray
        $0.numberOfLines = 1
    }

    private let infoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }

    private let destinationLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11)
        $0.textColor = .systemGray2
        $0.numberOfLines = 1
    }

    private let durationLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11)
        $0.textColor = .systemGray2
        $0.numberOfLines = 1
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
        contentView.addSubview(containerView)
        [thumbnailImageView, titleLabel, authorLabel, infoStackView].forEach {
            containerView.addSubview($0)
        }
        [destinationLabel, durationLabel].forEach {
            infoStackView.addArrangedSubview($0)
        }
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(10)
        }

        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(10)
        }

        infoStackView.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }

    // MARK: - Configuration

    func configure(with trip: PopularTrip) {
        titleLabel.text = trip.title
        authorLabel.text = trip.authorName
        destinationLabel.text = trip.destination
        durationLabel.text = "| \(trip.duration)"

        // TODO: 이미지 로딩 구현
        thumbnailImageView.backgroundColor = .systemGray4
    }
}
