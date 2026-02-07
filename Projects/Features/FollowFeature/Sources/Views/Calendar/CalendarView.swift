//
//  CalendarView.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core
import DSKit
import SnapKit
import Then
import UIKit

protocol CalendarViewDelegate: AnyObject {
    func calendarView(_ view: CalendarView, didSelectRange startDate: Date, endDate: Date)
    func calendarViewDidClearSelection(_ view: CalendarView)
}

final class CalendarView: UIView {

    // MARK: - Properties

    weak var delegate: CalendarViewDelegate?

    private var currentDate = Date()
    private var selectedStartDate: Date?
    private var selectedEndDate: Date?
    private var templateTotalDays: Int = 0

    private let calendar = Calendar.current
    private var days: [Int?] = []

    // MARK: - UI Components

    private let monthYearButton = UIButton(type: .system).then {
        $0.setTitleColor(UIColor(hexCode: "#111111"), for: .normal)
        $0.titleLabel?.font = UIFont.NDGL.subTitleMSB.font
    }

    private let previousMonthButton = UIButton(type: .system).then {
        $0.setImage(DSKitAsset.Assets.icChevronLeft3.image, for: .normal)
        $0.tintColor = UIColor(hexCode: "#111111")
    }

    private let nextMonthButton = UIButton(type: .system).then {
        $0.setImage(DSKitAsset.Assets.icChevronRight3.image, for: .normal)
        $0.tintColor = UIColor(hexCode: "#111111")
    }

    private let weekdayStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(CalendarDayCell.self, forCellWithReuseIdentifier: CalendarDayCell.identifier)
        return cv
    }()

    private let warningLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.isHidden = true
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupActions()
        setupWeekdayLabels()
        updateCalendar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = UIColor(hexCode: "#FFFFFF")

        [monthYearButton, previousMonthButton, nextMonthButton, weekdayStackView, collectionView, warningLabel].forEach {
            addSubview($0)
        }

        warningLabel.setText(
            .bodySR,
            text: "* 선택한 여행 기간이 따라가기 일정보다 짧아요.\n기간을 넘는 일정은 저장되지 않습니다.",
            color: DSKitAsset.Colors.red500.color
        )
    }

    private func setupConstraints() {
        monthYearButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(28)
        }

        nextMonthButton.snp.makeConstraints {
            $0.centerY.equalTo(monthYearButton)
            $0.trailing.equalToSuperview().offset(-16)
            $0.size.equalTo(24)
        }

        previousMonthButton.snp.makeConstraints {
            $0.centerY.equalTo(monthYearButton)
            $0.trailing.equalTo(nextMonthButton.snp.leading).offset(-8)
            $0.size.equalTo(24)
        }

        weekdayStackView.snp.makeConstraints {
            $0.top.equalTo(monthYearButton.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(20)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(weekdayStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(264)  // 6 rows * 44 height
        }

        warningLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-36)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }

    private func setupActions() {
        previousMonthButton.addTarget(self, action: #selector(previousMonthTapped), for: .touchUpInside)
        nextMonthButton.addTarget(self, action: #selector(nextMonthTapped), for: .touchUpInside)
        monthYearButton.addTarget(self, action: #selector(monthYearButtonTapped), for: .touchUpInside)
    }

    private func setupWeekdayLabels() {
        let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

        for (index, weekday) in weekdays.enumerated() {
            let label = UILabel()
            let color = index == 0 ? UIColor(hexCode: "#FB2C36") : UIColor(hexCode: "#2C2C2C")
            label.setText(.bodySR, text: weekday, color: color, alignment: .center)
            weekdayStackView.addArrangedSubview(label)
        }
    }

    // MARK: - Actions

    @objc private func previousMonthTapped() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        updateCalendar()
    }

    @objc private func nextMonthTapped() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        updateCalendar()
    }

    @objc private func monthYearButtonTapped() {
        showMonthYearPicker()
    }

    private func showMonthYearPicker() {
        guard let parentVC = findViewController() else { return }

        let alertController = UIAlertController(title: "년월 선택\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)

        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self

        // 현재 선택된 년월로 초기화
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let minYear = calendar.component(.year, from: Date())

        pickerView.selectRow(currentYear - minYear, inComponent: 0, animated: false)
        pickerView.selectRow(currentMonth - 1, inComponent: 1, animated: false)

        alertController.view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor),
            pickerView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 30),
            pickerView.widthAnchor.constraint(equalToConstant: 250),
            pickerView.heightAnchor.constraint(equalToConstant: 150)
        ])

        let selectAction = UIAlertAction(title: "선택", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let selectedYear = minYear + pickerView.selectedRow(inComponent: 0)
            let selectedMonth = pickerView.selectedRow(inComponent: 1) + 1

            var components = DateComponents()
            components.year = selectedYear
            components.month = selectedMonth
            components.day = 1

            if let date = self.calendar.date(from: components) {
                self.currentDate = date
                self.updateCalendar()
            }
        }
        alertController.addAction(selectAction)
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))

        parentVC.present(alertController, animated: true)
    }

    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }

    // MARK: - Calendar Logic

    private func updateCalendar() {
        updateMonthYearLabel()
        generateDays()
        updateCollectionViewHeight()
        collectionView.reloadData()
    }

    private func updateCollectionViewHeight() {
        let numberOfRows = days.count / 7
        let height = CGFloat(numberOfRows) * 44
        collectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }

    private func updateMonthYearLabel() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        let title = formatter.string(from: currentDate) + " ▾"
        monthYearButton.setTitle(title, for: .normal)
    }

    private func generateDays() {
        days.removeAll()

        let components = calendar.dateComponents([.year, .month], from: currentDate)
        guard let firstDayOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: currentDate) else {
            return
        }

        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)

        // 첫째 날 이전 빈 칸
        for _ in 1..<firstWeekday {
            days.append(nil)
        }

        // 실제 날짜
        for day in range {
            days.append(day)
        }

        // 마지막 줄 채우기 (7의 배수가 되도록)
        let remainder = days.count % 7
        if remainder != 0 {
            for _ in 0..<(7 - remainder) {
                days.append(nil)
            }
        }
    }

    private func dateFor(day: Int) -> Date? {
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        components.day = day
        return calendar.date(from: components)
    }

    private func isPastDate(_ date: Date) -> Bool {
        let today = calendar.startOfDay(for: Date())
        return date < today
    }

    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        return calendar.isDate(date1, inSameDayAs: date2)
    }

    private func selectionStateFor(date: Date) -> CalendarDayCell.SelectionState {
        if let start = selectedStartDate, isSameDay(date, start) {
            return .startDate
        }
        if let end = selectedEndDate, isSameDay(date, end) {
            return .endDate
        }
        if let start = selectedStartDate, let end = selectedEndDate {
            if date > start && date < end {
                return .inRange
            }
        }
        return .none
    }

    private func isInRange(_ date: Date) -> Bool {
        guard let start = selectedStartDate, let end = selectedEndDate else {
            return false
        }
        return date >= start && date <= end
    }

    // MARK: - Public Methods

    func getSelectedRange() -> (start: Date, end: Date)? {
        guard let start = selectedStartDate, let end = selectedEndDate else {
            return nil
        }
        return (start, end)
    }

    func setTemplateTotalDays(_ days: Int) {
        templateTotalDays = days
        updateWarningLabel()
    }

    // MARK: - Private Methods

    private func updateWarningLabel() {
        guard let start = selectedStartDate, let end = selectedEndDate else {
            warningLabel.isHidden = true
            return
        }

        let selectedDays = calendar.dateComponents([.day], from: start, to: end).day ?? 0
        let selectedTotalDays = selectedDays + 1  // 시작일 포함

        // 선택한 기간이 템플릿 일정보다 짧을 때만 경고 표시
        warningLabel.isHidden = selectedTotalDays >= templateTotalDays
    }
}

// MARK: - UICollectionViewDataSource

extension CalendarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarDayCell.identifier,
            for: indexPath
        ) as? CalendarDayCell else {
            return UICollectionViewCell()
        }

        let day = days[indexPath.item]
        let isSunday = indexPath.item % 7 == 0

        var selectionState: CalendarDayCell.SelectionState = .none
        var isPast = false

        if let day = day, let date = dateFor(day: day) {
            isPast = isPastDate(date)
            selectionState = selectionStateFor(date: date)
        }

        cell.configure(
            day: day,
            isCurrentMonth: day != nil,
            isSunday: isSunday,
            isPastDate: isPast,
            selectionState: selectionState
        )

        if let day = day, let date = dateFor(day: day) {
            let isStart = selectedStartDate.map { isSameDay(date, $0) } ?? false
            let isEnd = selectedEndDate.map { isSameDay(date, $0) } ?? false
            let inRange = isInRange(date)

            if isStart && selectedEndDate != nil {
                cell.configureRangeBackground(showLeft: false, showRight: true)
            } else if isEnd && selectedStartDate != nil {
                cell.configureRangeBackground(showLeft: true, showRight: false)
            } else if inRange && !isStart && !isEnd {
                cell.configureRangeBackground(showLeft: true, showRight: true)
            } else {
                cell.configureRangeBackground(showLeft: false, showRight: false)
            }
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CalendarView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let day = days[indexPath.item],
              let date = dateFor(day: day),
              !isPastDate(date) else {
            return
        }

        if selectedStartDate == nil {
            selectedStartDate = date
            selectedEndDate = nil
        } else if let startDate = selectedStartDate, selectedEndDate == nil {
            if date < startDate {
                selectedEndDate = selectedStartDate
                selectedStartDate = date
            } else if isSameDay(date, startDate) {
                selectedStartDate = nil
                selectedEndDate = nil
                delegate?.calendarViewDidClearSelection(self)
            } else {
                selectedEndDate = date
            }
        } else {
            selectedStartDate = date
            selectedEndDate = nil
        }

        collectionView.reloadData()
        updateWarningLabel()

        if let start = selectedStartDate, let end = selectedEndDate {
            delegate?.calendarView(self, didSelectRange: start, endDate: end)
        } else {
            delegate?.calendarViewDidClearSelection(self)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 7
        return CGSize(width: width, height: 44)
    }
}

// MARK: - UIPickerViewDataSource

extension CalendarView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            let currentYear = calendar.component(.year, from: Date())
            return 2099 - currentYear + 1
        } else {
            return 12
        }
    }
}

// MARK: - UIPickerViewDelegate

extension CalendarView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let currentYear = calendar.component(.year, from: Date())
            return "\(currentYear + row)년"
        } else {
            return "\(row + 1)월"
        }
    }
}
