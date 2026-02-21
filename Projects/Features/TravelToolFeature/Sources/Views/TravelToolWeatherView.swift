//
//  TravelToolWeatherView.swift
//  TravelToolFeature
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import Domain
import DSKit

final class TravelToolWeatherView: UIView {
    private let iconImageView = UIImageView()
    private let temperatureLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let humidityLabel = UILabel()
    private let infoStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with info: WeatherInfo) {
        temperatureLabel.setText(
            .subTitleMSB,
            text: "\(Int(info.temperature))°",
            color: DSKitAsset.Colors.black700.color
        )
        descriptionLabel.setText(
            .bodyMR,
            text: info.description,
            color: DSKitAsset.Colors.black600.color
        )
        humidityLabel.setText(
            .bodyMR,
            text: "습도 \(info.humidity)%",
            color: DSKitAsset.Colors.black400.color
        )

        if let url = URL(string: info.iconUrl) {
            iconImageView.kf.setImage(with: url)
        }
    }
}

private extension TravelToolWeatherView {
    func setStyle() {
        backgroundColor = DSKitAsset.Colors.black50.color
        layer.cornerRadius = 8.adjustedH
        clipsToBounds = true

        iconImageView.do {
            $0.contentMode = .scaleAspectFit
        }

        infoStackView.do {
            $0.axis = .vertical
            $0.spacing = 4.adjustedH
            $0.alignment = .leading
        }
    }

    func setUI() {
        addSubviews(iconImageView, infoStackView)
        infoStackView.addArrangedSubviews(temperatureLabel, descriptionLabel, humidityLabel)
    }

    func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.adjusted)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(48.adjustedH)
        }

        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12.adjusted)
            $0.trailing.lessThanOrEqualToSuperview().inset(16.adjusted)
            $0.top.bottom.equalToSuperview().inset(12.adjustedH)
        }
    }
}
