//
//  UpcomingTripCell.swift
//  TravelFeature
//
//  Created by kimnahun on 2026-01-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import DSKit
import Kingfisher
import SnapKit
import Then
import UIKit

final class UpcomingTripCell: UICollectionViewCell {

    static let identifier = "UpcomingTripCell"

    // MARK: - UI Components

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
    }

    private let dDayBadge = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.primary500.color
        $0.layer.cornerRadius = 10
    }

    private let dDayLabel = UILabel()

    private let titleLabel = UILabel()

    private let dateLabel = UILabel()

    // D-day + 날짜를 세로로 묶는 스택뷰
    private let dDayStackView = UIStackView().then {
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
        thumbnailImageView.backgroundColor = .systemGray5
    }

    // MARK: - Setup

    private func setupUI() {
        [thumbnailImageView, dDayStackView, titleLabel].forEach {
            contentView.addSubview($0)
        }

        dDayBadge.addSubview(dDayLabel)

        [dDayBadge, dateLabel].forEach {
            dDayStackView.addArrangedSubview($0)
        }
    }

    private func setupConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(48)
        }

        dDayStackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }

        dDayBadge.snp.makeConstraints {
            $0.height.equalTo(20)
        }

        dDayLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8))
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(dDayStackView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(dDayBadge)
        }
    }

    // MARK: - Configuration

    func configure(with trip: UpcomingTrip) {
        // D-day
        let dDay = trip.dDay
        let dDayText = dDay > 0 ? "D-\(dDay)" : (dDay == 0 ? "D-Day" : "D+\(abs(dDay))")
        dDayLabel.setText(.bodySSB, text: dDayText, color: .white)

        // Title
        titleLabel.setText(.bodyMSB, text: trip.title, color: UIColor.NDGL.Text.primary)

        // Date range
        dateLabel.setText(.bodySR, text: trip.dateRangeString, color: UIColor.NDGL.Text.tertiary)

        // Thumbnail
        if let urlString = trip.thumbnailURL, let url = URL(string: urlString) {
            thumbnailImageView.kf.setImage(
                with: url,
                options: [.transition(.fade(0.2)), .cacheOriginalImage]
            )
        }
    }
}
