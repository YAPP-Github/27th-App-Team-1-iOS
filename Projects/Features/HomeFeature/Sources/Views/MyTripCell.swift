//
//  MyTripCell.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import UIKit

import SnapKit
import Then

final class MyTripCell: UICollectionViewCell {

    static let identifier = "MyTripCell"

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
        $0.numberOfLines = 1
    }

    private let destinationLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .systemGray
        $0.numberOfLines = 1
    }

    private let dateLabel = UILabel().then {
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
        [thumbnailImageView, titleLabel, destinationLabel, dateLabel].forEach {
            containerView.addSubview($0)
        }
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }

        destinationLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(8)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(destinationLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }

    // MARK: - Configuration

    func configure(with trip: MyTrip) {
        titleLabel.text = trip.title
        destinationLabel.text = trip.destination

        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        let startDateString = formatter.string(from: trip.startDate)
        let endDateString = formatter.string(from: trip.endDate)
        dateLabel.text = "\(startDateString) - \(endDateString)"

        // TODO: 이미지 로딩 구현
        thumbnailImageView.backgroundColor = .systemGray4
    }
}
