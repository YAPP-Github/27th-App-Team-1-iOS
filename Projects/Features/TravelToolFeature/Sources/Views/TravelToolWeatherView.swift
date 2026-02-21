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

// MARK: - Weather State

enum TravelToolWeatherState {
    case noTrip
    case preparing
    case hasWeather(title: String, forecasts: [DailyWeatherInfo])
}

// MARK: - TravelToolWeatherView

final class TravelToolWeatherView: UIView {
    private let titleLabel = UILabel()
    private let contentStackView = UIStackView()
    private let noTripView = WeatherEmptyContentView(
        message: "아직 예정된 여행이 없어요.",
        subMessage: "따라가기 영상을 담아두면 여행 준비가 쉬워져요."
    )
    private let preparingView = WeatherEmptyContentView(
        message: "아직 날씨 정보를 준비하고 있어요.",
        subMessage: nil
    )
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.register(WeatherDayCell.self, forCellWithReuseIdentifier: WeatherDayCell.identifier)
        return cv
    }()

    private var forecasts: [DailyWeatherInfo] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setUI()
        setLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ state: TravelToolWeatherState) {
        noTripView.isHidden = true
        preparingView.isHidden = true
        collectionView.isHidden = true

        switch state {
        case .noTrip:
            titleLabel.setText(.subTitleMSB, text: "여행 중 날씨", color: DSKitAsset.Colors.black700.color)
            noTripView.isHidden = false

        case .preparing:
            titleLabel.setText(.subTitleMSB, text: "여행 중 날씨", color: DSKitAsset.Colors.black700.color)
            preparingView.isHidden = false

        case .hasWeather(let title, let forecasts):
            titleLabel.setText(.subTitleMSB, text: "\(title) 여행 중 날씨", color: DSKitAsset.Colors.black700.color)
            self.forecasts = forecasts
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
}

// MARK: - Private

private extension TravelToolWeatherView {
    func setStyle() {
        backgroundColor = .clear

        titleLabel.do {
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }

        contentStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }

    func setUI() {
        addSubviews(titleLabel, contentStackView)
        contentStackView.addArrangedSubviews(noTripView, preparingView, collectionView)
    }

    func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.adjustedH)
            $0.leading.equalToSuperview().inset(20.adjusted)
            $0.trailing.lessThanOrEqualToSuperview().inset(20.adjusted)
        }

        contentStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjustedH)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20.adjustedH)
        }

        collectionView.snp.makeConstraints {
            $0.height.equalTo(140.adjustedH)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension TravelToolWeatherView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecasts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeatherDayCell.identifier,
            for: indexPath
        ) as? WeatherDayCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: forecasts[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TravelToolWeatherView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 100.adjusted, height: 140.adjustedH)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 20.adjusted, bottom: 0, right: 20.adjusted)
    }
}

// MARK: - WeatherDayCell

final class WeatherDayCell: UICollectionViewCell {
    static let identifier = "WeatherDayCell"

    private let dateLabel = UILabel()
    private let dayOfWeekLabel = UILabel()
    private let iconImageView = UIImageView()
    private let tempLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with info: DailyWeatherInfo) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")

        dateFormatter.dateFormat = "MM.dd"
        dateLabel.setText(.bodyLSB, text: dateFormatter.string(from: info.date), color: DSKitAsset.Colors.black700.color)

        dateFormatter.dateFormat = "EEEE"
        dayOfWeekLabel.setText(.bodySR, text: dateFormatter.string(from: info.date), color: DSKitAsset.Colors.black400.color)

        tempLabel.setText(
            .bodyMR,
            text: "\(Int(info.maxTemperature))° / \(Int(info.minTemperature))°",
            color: DSKitAsset.Colors.black600.color
        )

        iconImageView.image = WeatherIconMapper.icon(for: info.weatherType)
    }

    private func setStyle() {
        iconImageView.do {
            $0.contentMode = .scaleAspectFit
        }

        dateLabel.textAlignment = .center
        dayOfWeekLabel.textAlignment = .center
        tempLabel.textAlignment = .center
    }

    private func setUI() {
        contentView.addSubviews(dateLabel, dayOfWeekLabel, iconImageView, tempLabel)
    }

    private func setLayout() {
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        dayOfWeekLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(2.adjustedH)
            $0.centerX.equalToSuperview()
        }

        iconImageView.snp.makeConstraints {
            $0.top.equalTo(dayOfWeekLabel.snp.bottom).offset(8.adjustedH)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(48.adjustedH)
        }

        tempLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(8.adjustedH)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - WeatherEmptyContentView

final class WeatherEmptyContentView: UIView {
    private let imageView = UIImageView()
    private let messageLabel = UILabel()
    private let subMessageLabel = UILabel()
    private let stackView = UIStackView()

    init(message: String, subMessage: String?) {
        super.init(frame: .zero)

        setStyle(message: message, subMessage: subMessage)
        setUI(hasSubMessage: subMessage != nil)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setStyle(message: String, subMessage: String?) {
        imageView.do {
            $0.image = DSKitAsset.Assets.icEmptyTrip.image
            $0.contentMode = .scaleAspectFit
        }

        messageLabel.do {
            $0.setText(.bodyLSB, text: message, color: DSKitAsset.Colors.black700.color)
            $0.textAlignment = .center
        }

        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 4.adjustedH
        }

        if let subMessage {
            subMessageLabel.do {
                $0.setText(.bodyMR, text: subMessage, color: DSKitAsset.Colors.black400.color)
                $0.textAlignment = .center
            }
        }
    }

    private func setUI(hasSubMessage: Bool) {
        addSubview(stackView)
        stackView.addArrangedSubviews(imageView, messageLabel)
        if hasSubMessage {
            stackView.addArrangedSubview(subMessageLabel)
        }
    }

    private func setLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(120.adjustedH)
        }

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.adjustedH)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8.adjustedH)
        }
    }
}

// MARK: - WeatherIconMapper

enum WeatherIconMapper {
    static func icon(for type: String) -> UIImage {
        switch type {
        case "CLEAR":
            return DSKitAsset.Assets.icWeatherSunny.image
        case "MOSTLY_CLEAR":
            return DSKitAsset.Assets.icWeatherSunClouds01.image
        case "PARTLY_CLOUDY":
            return DSKitAsset.Assets.icWeatherSunClouds01.image
        case "MOSTLY_CLOUDY":
            return DSKitAsset.Assets.icWeatherSunClouds02.image
        case "CLOUDY", "FOGGY":
            return DSKitAsset.Assets.icWeatherCloud.image
        case "LIGHT_RAIN", "SCATTERED_SHOWERS":
            return DSKitAsset.Assets.icWeatherSunRain.image
        case "RAIN", "HEAVY_RAIN", "SHOWERS":
            return DSKitAsset.Assets.icWeatherRain.image
        case "LIGHT_SNOW", "SNOW", "HEAVY_SNOW", "BLIZZARD", "FLURRIES":
            return DSKitAsset.Assets.icWeatherCloud.image
        case "THUNDERSTORM", "THUNDERSTORMS":
            return DSKitAsset.Assets.icWeatherThunder.image
        default:
            return DSKitAsset.Assets.icWeatherCloud.image
        }
    }
}
