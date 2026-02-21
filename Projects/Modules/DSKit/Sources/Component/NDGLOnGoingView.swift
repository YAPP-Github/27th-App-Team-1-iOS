//
//  NDGLOnGoingView.swift
//  DSKit
//
//  Created by kimnahun on 2026-02-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import Kingfisher
import SnapKit
import Then

public final class NDGLOnGoingView: UIView {
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let iconImageView = UIImageView()
    private let transportLabel = UILabel()
    private let dotLabel = UILabel()
    private let durationLabel = UILabel()
    private let placeLabel = UILabel()
    private let imageView = UIImageView()
    private let titleStackView = UIStackView()
    private let subInfoStackView = UIStackView()
    private let infoStackView = UIStackView()
    private let routeStackView = UIStackView()
    private let routeCardView = UIView()
    private let containerStackView = UIStackView()

    override public init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(
        title: String,
        date: String,
        transportIcon: UIImage?,
        transport: String,
        duration: String,
        place: String,
        imageUrl: String
    ) {
        titleLabel.setText(.bodyMSB, text: title, color: DSKitAsset.Colors.black700.color)
        dateLabel.setText(.bodyMR, text: date, color: DSKitAsset.Colors.black500.color)
        iconImageView.image = transportIcon?.withRenderingMode(.alwaysTemplate)
        transportLabel.setText(.bodySM, text: transport, color: DSKitAsset.Colors.black400.color)
        durationLabel.setText(.bodySM, text: "\(duration) 체류 예상", color: DSKitAsset.Colors.black400.color)
        placeLabel.setText(.bodyLSB, text: place, color: DSKitAsset.Colors.black900.color)

        if let url = URL(string: imageUrl) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.backgroundColor = .systemGray5
        }
    }

    public func prepareForReuse() {
        imageView.kf.cancelDownloadTask()
        titleLabel.text = nil
        dateLabel.text = nil
        placeLabel.text = nil
        durationLabel.text = nil
        imageView.image = nil
        iconImageView.image = nil
        transportLabel.text = nil
    }
}

private extension NDGLOnGoingView {
    func setStyle() {
        backgroundColor = .clear

        dotLabel.do {
            $0.setText(.bodyMM, text: "•", color: DSKitAsset.Colors.black400.color)
        }

        iconImageView.do {
            $0.tintColor = DSKitAsset.Colors.black500.color
        }

        imageView.do {
            $0.layer.cornerRadius = 4.adjustedH
            $0.backgroundColor = .systemGray6
            $0.clipsToBounds = true
        }

        titleStackView.do {
            $0.axis = .vertical
            $0.spacing = 4.adjustedH
            $0.alignment = .leading
        }

        subInfoStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4.adjusted
            $0.alignment = .center
        }

        infoStackView.do {
            $0.axis = .vertical
            $0.spacing = 10.adjustedH
            $0.alignment = .leading
        }

        routeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12.adjusted
            $0.alignment = .center
        }

        routeCardView.do {
            $0.backgroundColor = DSKitAsset.Colors.white.color
            $0.layer.cornerRadius = 16.adjustedH
            $0.clipsToBounds = true
        }

        containerStackView.do {
            $0.axis = .vertical
            $0.spacing = 16.adjustedH
            $0.alignment = .leading
        }
    }

    func setUI() {
        titleStackView.addArrangedSubviews(titleLabel, dateLabel)
        subInfoStackView.addArrangedSubviews(iconImageView, transportLabel, dotLabel, durationLabel)
        infoStackView.addArrangedSubviews(subInfoStackView, placeLabel)
        routeStackView.addArrangedSubviews(infoStackView, imageView)
        routeCardView.addSubview(routeStackView)
        containerStackView.addArrangedSubviews(titleStackView, routeCardView)
        addSubview(containerStackView)
    }

    func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(14.adjustedH)
        }

        imageView.snp.makeConstraints {
            $0.size.equalTo(56.adjustedH)
        }

        routeStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(16.adjusted)
            $0.top.equalToSuperview().inset(12.adjustedH)
            $0.bottom.equalToSuperview().inset(16.adjustedH)
        }

        routeCardView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }

        titleStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
        }

        containerStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(16.adjusted)
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.bottom.equalToSuperview().inset(23.adjustedH).priority(.low)
        }
    }
}
