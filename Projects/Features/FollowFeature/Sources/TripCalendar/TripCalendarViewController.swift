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

    private let calendarView = CalendarView()

    private let completeButton = BottomPlacedButton(title: "완료")

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupDelegates()
        setupActions()
        updateCompleteButtonState()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            listener?.didTapBackButton()
        }
    }

    // MARK: - Setup

    private func setupUI() {
        title = "여행 따라가기"
        view.backgroundColor = UIColor(hexCode: "#FFFFFF")

        [calendarView, completeButton].forEach {
            view.addSubview($0)
        }
    }

    private func setupConstraints() {
        calendarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalToSuperview()
        }

        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(52)
        }
    }

    private func setupDelegates() {
        calendarView.delegate = self
    }

    private func setupActions() {
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func completeButtonTapped() {
        guard let start = selectedStartDate, let end = selectedEndDate else { return }
        listener?.didTapCompleteButton(startDate: start, endDate: end)
    }

    private func updateCompleteButtonState() {
        let isEnabled = selectedStartDate != nil && selectedEndDate != nil

        if isEnabled {
            completeButton.backgroundColor = UIColor(hexCode: "#111111")
            completeButton.isEnabled = true
        } else {
            completeButton.backgroundColor = UIColor(hexCode: "#B3B3B3")
            completeButton.isEnabled = false
        }
    }

    // MARK: - Public Methods

    func setTemplateTotalDays(_ days: Int) {
        calendarView.setTemplateTotalDays(days)
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
