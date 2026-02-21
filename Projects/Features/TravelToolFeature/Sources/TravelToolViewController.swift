//
//  TravelToolViewController.swift
//  TravelToolFeature
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs
import UIKit

import Domain
import DSKit

// MARK: - TravelToolViewController

final class TravelToolViewController: UIViewController, TravelToolPresentable, TravelToolViewControllable {

    // MARK: - Properties

    weak var listener: TravelToolPresentableListener?

    // MARK: - UI

    private let tripCardView = TravelToolTripCardView()
    private let weatherView = TravelToolWeatherView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setStyle()
        setUI()
        setLayout()
    }

    // MARK: - TravelToolPresentable

    func updateTripCard(_ state: TravelToolTripState) {
         tripCardView.configure(state)
    }

    func updateWeather(_ info: WeatherInfo?) {
        if let info {
            weatherView.isHidden = false
            weatherView.configure(with: info)
        } else {
            weatherView.isHidden = true
        }
    }
}

// MARK: - Private

private extension TravelToolViewController {
    func setStyle() {
        view.backgroundColor = .white
        weatherView.isHidden = true
    }

    func setUI() {
        view.addSubviews(tripCardView, weatherView)
    }

    func setLayout() {
        tripCardView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24.adjusted)
        }

        weatherView.snp.makeConstraints {
            $0.top.equalTo(tripCardView.snp.bottom).offset(16.adjustedH)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24.adjusted)
        }
    }
}
