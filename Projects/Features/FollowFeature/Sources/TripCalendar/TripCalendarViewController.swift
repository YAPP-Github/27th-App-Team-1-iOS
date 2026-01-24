//
//  TripCalendarViewController.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core
import DSKit
import RIBs
import SnapKit
import Then
import UIKit

// MARK: - TripCalendarViewController

final class TripCalendarViewController: UIViewController, TripCalendarPresentable, TripCalendarViewControllable {

    // MARK: - Properties

    weak var listener: TripCalendarPresentableListener?
    private var selectedStartDate: Date?
    private var selectedEndDate: Date?

    // MARK: - UI Components

    private let navigationBar = UIView()

    private let backButton = UIButton(type: .system).then {
        $0.setImage(DSKitAsset.Assets.icChevronLeft3.image, for: .normal)
        $0.tintColor = UIColor.NDGL.Icon.primary
    }

    private let titleLabel = UILabel()

    private let calendarView = CalendarView()

    private let completeButton = BottomPlacedButton(title: "완료")

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        updateCompleteButtonState()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = UIColor.NDGL.Bg.primary

        [navigationBar, calendarView, completeButton].forEach {
            view.addSubview($0)
        }

        [backButton, titleLabel].forEach {
            navigationBar.addSubview($0)
        }

        titleLabel.setText(.subTitleMSB, text: "새로운 여행 만들기", color: UIColor.NDGL.Text.primary, alignment: .center)

        calendarView.delegate = self
    }

    private func setupConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }

        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        calendarView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(350)
        }

        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(52)
        }
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func backButtonTapped() {
        listener?.didTapBackButton()
    }

    @objc private func completeButtonTapped() {
        guard let start = selectedStartDate, let end = selectedEndDate else { return }
        listener?.didTapCompleteButton(startDate: start, endDate: end)
    }

    // MARK: - Private Methods

    private func updateCompleteButtonState() {
        let isEnabled = selectedStartDate != nil && selectedEndDate != nil

        if isEnabled {
            completeButton.backgroundColor = UIColor(hexCode: "#111111")
            completeButton.isEnabled = true
        } else {
            completeButton.backgroundColor = UIColor.NDGL.Bg.disabled
            completeButton.isEnabled = false
        }
    }
}

// MARK: - CalendarViewDelegate

extension TripCalendarViewController: CalendarViewDelegate {
    func calendarView(_ view: CalendarView, didSelectRange startDate: Date, endDate: Date) {
        selectedStartDate = startDate
        selectedEndDate = endDate
        updateCompleteButtonState()
    }

    func calendarViewDidClearSelection(_ view: CalendarView) {
        selectedStartDate = nil
        selectedEndDate = nil
        updateCompleteButtonState()
    }
}
