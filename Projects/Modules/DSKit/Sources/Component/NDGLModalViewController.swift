//
//  NDGLModalViewController.swift
//  DSKit
//
//  Created by kimnahun on 2/6/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import SnapKit
import Then
import UIKit

public final class NDGLModalViewController: UIViewController {

    // MARK: - Properties

    public var onCancelTapped: (() -> Void)?
    public var onActionTapped: (() -> Void)?

    private let modalTitle: String
    private let modalSubtitle: String
    private let modalDescription: String?
    private let cancelButtonTitle: String
    private let actionButtonTitle: String

    // MARK: - UI Components

    private let dimView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

    private let containerView = UIView().then {
        $0.backgroundColor = UIColor(hexCode: "#FFFFFF")
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    private let subtitleLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.isHidden = true
    }

    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }

    private let cancelButton = UIButton(type: .system).then {
        $0.backgroundColor = DSKitAsset.Colors.black50.color
        $0.layer.cornerRadius = 12
    }

    private let actionButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor(hexCode: "#111111")
        $0.layer.cornerRadius = 12
    }

    // MARK: - Initialization

    public init(
        title: String,
        subtitle: String,
        description: String? = nil,
        cancelButtonTitle: String = "취소",
        actionButtonTitle: String
    ) {
        self.modalTitle = title
        self.modalSubtitle = subtitle
        self.modalDescription = description
        self.cancelButtonTitle = cancelButtonTitle
        self.actionButtonTitle = actionButtonTitle
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        configureContent()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .clear

        view.addSubview(dimView)
        view.addSubview(containerView)

        [titleLabel, subtitleLabel, descriptionLabel, buttonStackView].forEach {
            containerView.addSubview($0)
        }

        [cancelButton, actionButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
    }

    private func setupConstraints() {
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30.adjusted)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32.adjusted)
            $0.centerX.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjusted)
            $0.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(12.adjusted)
            $0.leading.trailing.equalToSuperview().inset(28.adjusted)
        }

        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(28.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjusted)
            $0.bottom.equalToSuperview().offset(-24.adjustedH)
            $0.height.equalTo(40.adjustedH)
        }
    }

    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimViewTapped))
        dimView.addGestureRecognizer(tapGesture)
    }

    private func configureContent() {
        titleLabel.setText(.subTitleLSB, text: modalTitle, color: DSKitAsset.Colors.black900.color, alignment: .center)
        subtitleLabel.setText(.bodyMM, text: modalSubtitle, color: DSKitAsset.Colors.black500.color, alignment: .center)

        if let description = modalDescription {
            descriptionLabel.isHidden = false
            descriptionLabel.setText(.bodyMM, text: description, color: DSKitAsset.Colors.black400.color, alignment: .center)
        } else {
            descriptionLabel.isHidden = true
            buttonStackView.snp.remakeConstraints {
                $0.top.equalTo(subtitleLabel.snp.bottom).offset(28.adjustedH)
                $0.leading.trailing.equalToSuperview().inset(24.adjusted)
                $0.bottom.equalToSuperview().offset(-24.adjustedH)
                $0.height.equalTo(40.adjustedH)
            }
        }

        cancelButton.setAttributedTitle(
            NSAttributedString(
                string: cancelButtonTitle,
                attributes: [
                    .font: UIFont.NDGL.bodyMSB.font,
                    .foregroundColor: DSKitAsset.Colors.black600.color
                ]
            ),
            for: .normal
        )

        actionButton.setAttributedTitle(
            NSAttributedString(
                string: actionButtonTitle,
                attributes: [
                    .font: UIFont.NDGL.bodyMSB.font,
                    .foregroundColor: UIColor(hexCode: "#FFFFFF")
                ]
            ),
            for: .normal
        )
    }

    // MARK: - Actions

    @objc private func cancelButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onCancelTapped?()
        }
    }

    @objc private func actionButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onActionTapped?()
        }
    }

    @objc private func dimViewTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onCancelTapped?()
        }
    }
}
