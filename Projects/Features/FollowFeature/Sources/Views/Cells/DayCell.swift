//
//  DayCell.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core
import DSKit
import SnapKit
import Then
import UIKit

final class DayCell: UICollectionViewCell {

    static let identifier = "DayCell"

    // MARK: - UI Components

    private let containerView = UIView().then {
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hexCode: "#D9D9D9").cgColor
        $0.backgroundColor = UIColor(hexCode: "#FFFFFF")
    }

    private let dayLabel = UILabel()

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            updateSelectionState()
        }
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

    // MARK: - Setup

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(dayLabel)
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        dayLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    // MARK: - Configuration

    func configure(day: Int) {
        dayLabel.text = "\(day)일차"
        updateSelectionState()
    }

    private func updateSelectionState() {
        if isSelected {
            containerView.backgroundColor = UIColor(hexCode: "#2C2C2C")
            containerView.layer.borderWidth = 0
            dayLabel.font = UIFont.NDGL.bodyMM.font
            dayLabel.textColor = UIColor(hexCode: "#FFFFFF")
        } else {
            containerView.backgroundColor = UIColor(hexCode: "#FFFFFF")
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor(hexCode: "#D9D9D9").cgColor
            dayLabel.font = UIFont.NDGL.bodyMM.font
            dayLabel.textColor = UIColor(hexCode: "#757575")
        }
    }
}
