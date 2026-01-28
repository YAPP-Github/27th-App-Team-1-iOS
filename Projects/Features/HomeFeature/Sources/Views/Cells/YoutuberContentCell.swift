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

    // MARK: - Properties

    private var currentThumbnailURL: String?

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
        currentThumbnailURL = nil
        thumbnailImageView.kf.cancelDownloadTask()
        thumbnailImageView.image = nil
        thumbnailImageView.backgroundColor = .systemGray5
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

    /// Configures the cell using a PopularTrip model, updating visibility, labels, and the thumbnail.
    /// - Parameter trip: The PopularTrip used to populate the cell. If `trip.id` is less than 0 the cell is hidden.
    /// 
    /// After configuration the title and info labels are set, the current thumbnail URL is recorded and a thumbnail image load is attempted. If no valid thumbnail URL is provided or the most recent image load fails, the thumbnail view's background is set to `systemGray5`. Image load results are applied only when they correspond to the most recently requested thumbnail URL.

    func configure(with trip: PopularTrip) {
        // placeholder trip인 경우 숨김 처리
        guard trip.id >= 0 else {
            contentView.isHidden = true
            return
        }
        contentView.isHidden = false

        titleLabel.setText(.bodyMSB, text: trip.title, color: UIColor(hexCode: "#2C2C2C"))
        infoLabel.setText(.bodySM, text: "\(trip.authorName) · \(trip.destination) · \(trip.duration)", color: UIColor(hexCode: "#2C2C2C"))

        // URL 저장 및 이미지 로딩 (교차 검증)
        let thumbnailURL = trip.thumbnailURL
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
                // 교차 검증: 현재 URL이 요청한 URL과 같은지 확인
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