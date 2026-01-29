//
//  CalendarDayCell.swift
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

final class CalendarDayCell: UICollectionViewCell {

    static let identifier = "CalendarDayCell"

    // MARK: - UI Components

    private let backgroundCircleView = UIView().then {
        $0.isHidden = true
    }

    private let rangeBackgroundView = UIView().then {
        $0.backgroundColor = UIColor(hexCode: "#C6F6D5")
        $0.isHidden = true
    }

    private let dayLabel = UILabel()

    // MARK: - Properties

    enum SelectionState {
        case none
        case startDate
        case endDate
        case inRange
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
        backgroundCircleView.isHidden = true
        rangeBackgroundView.isHidden = true
        dayLabel.text = nil
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.addSubview(rangeBackgroundView)
        contentView.addSubview(backgroundCircleView)
        contentView.addSubview(dayLabel)

        backgroundCircleView.layer.cornerRadius = 18
    }

    private func setupConstraints() {
        rangeBackgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(36)
        }

        backgroundCircleView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(36)
        }

        dayLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    // MARK: - Configuration

    func configure(
        day: Int?,
        isCurrentMonth: Bool,
        isSunday: Bool,
        isPastDate: Bool,
        selectionState: SelectionState
    ) {
        guard let day = day else {
            dayLabel.text = nil
            backgroundCircleView.isHidden = true
            rangeBackgroundView.isHidden = true
            return
        }

        dayLabel.text = "\(day)"

        backgroundCircleView.isHidden = true
        backgroundCircleView.layer.borderWidth = 0
        rangeBackgroundView.isHidden = true

        var textColor: UIColor

        if !isCurrentMonth {
            textColor = UIColor(hexCode: "#757575")
        } else if isPastDate {
            if isSunday {
                textColor = UIColor(hexCode: "#FFA2A2")
            } else {
                textColor = UIColor(hexCode: "#757575")
            }
        } else if isSunday {
            textColor = UIColor(hexCode: "#FB2C36")
        } else {
            textColor = UIColor(hexCode: "#111111")
        }

        switch selectionState {
        case .startDate, .endDate:
            backgroundCircleView.backgroundColor = UIColor(hexCode: "#38A169")
            backgroundCircleView.isHidden = false
            textColor = UIColor(hexCode: "#FFFFFF")

        case .inRange:
            rangeBackgroundView.isHidden = false

        case .none:
            break
        }

        dayLabel.setText(.bodyMM, text: "\(day)", color: textColor)
    }

    func configureRangeBackground(showLeft: Bool, showRight: Bool) {
        if showLeft || showRight {
            rangeBackgroundView.isHidden = false

            if showLeft && showRight {
                rangeBackgroundView.snp.remakeConstraints {
                    $0.leading.trailing.equalToSuperview()
                    $0.centerY.equalToSuperview()
                    $0.height.equalTo(36)
                }
            } else if showLeft {
                rangeBackgroundView.snp.remakeConstraints {
                    $0.leading.equalToSuperview()
                    $0.trailing.equalTo(contentView.snp.centerX)
                    $0.centerY.equalToSuperview()
                    $0.height.equalTo(36)
                }
            } else if showRight {
                rangeBackgroundView.snp.remakeConstraints {
                    $0.leading.equalTo(contentView.snp.centerX)
                    $0.trailing.equalToSuperview()
                    $0.centerY.equalToSuperview()
                    $0.height.equalTo(36)
                }
            }
        } else {
            rangeBackgroundView.isHidden = true
        }
    }
}
