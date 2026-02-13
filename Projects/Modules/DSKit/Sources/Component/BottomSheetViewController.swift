//
//  BottomSheetViewController.swift
//  DSKit
//
//  Created by kimnahun on 2026-01-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

// MARK: - BottomSheetConfiguration

public struct BottomSheetConfiguration {
    public let showDim: Bool
    public let dimColor: UIColor
    public let showIndicator: Bool
    public let cornerRadius: CGFloat
    public let dismissOnTapDim: Bool

    public init(
        showDim: Bool = true,
        dimColor: UIColor = UIColor.black.withAlphaComponent(0.7),
        showIndicator: Bool = true,
        cornerRadius: CGFloat = 20,
        dismissOnTapDim: Bool = true
    ) {
        self.showDim = showDim
        self.dimColor = dimColor
        self.showIndicator = showIndicator
        self.cornerRadius = cornerRadius
        self.dismissOnTapDim = dismissOnTapDim
    }

    public static let `default` = BottomSheetConfiguration()
}

// MARK: - BottomSheetViewController

open class BottomSheetViewController: UIViewController {

    // MARK: - Properties

    private let configuration: BottomSheetConfiguration
    private let contentView: UIView
    private var contentHeight: CGFloat

    // MARK: - UI Components

    private lazy var dimView: UIView = {
        let view = UIView()
        view.backgroundColor = configuration.dimColor
        view.alpha = 0
        if configuration.dismissOnTapDim {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimViewTapped))
            view.addGestureRecognizer(tapGesture)
        }
        return view
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = configuration.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()

    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        view.layer.cornerRadius = 2.5
        return view
    }()

    // MARK: - Initialization

    public init(
        contentView: UIView,
        contentHeight: CGFloat,
        configuration: BottomSheetConfiguration = .default
    ) {
        self.contentView = contentView
        self.contentHeight = contentHeight
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupPanGesture()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .clear

        if configuration.showDim {
            view.addSubview(dimView)
        }

        view.addSubview(containerView)

        if configuration.showIndicator {
            containerView.addSubview(indicatorView)
        }

        containerView.addSubview(contentView)
    }

    private func setupConstraints() {
        if configuration.showDim {
            dimView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }

        let indicatorHeight: CGFloat = configuration.showIndicator ? 24 : 0
        let totalHeight = contentHeight + indicatorHeight + view.safeAreaInsets.bottom

        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(totalHeight)
            $0.height.equalTo(totalHeight)
        }

        if configuration.showIndicator {
            indicatorView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(8)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(36)
                $0.height.equalTo(5)
            }

            contentView.snp.makeConstraints {
                $0.top.equalTo(indicatorView.snp.bottom).offset(8)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(containerView.safeAreaLayoutGuide)
            }
        } else {
            contentView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(containerView.safeAreaLayoutGuide)
            }
        }
    }

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        containerView.addGestureRecognizer(panGesture)
    }

    // MARK: - Animation

    private func showBottomSheet() {
        let indicatorHeight: CGFloat = configuration.showIndicator ? 24 : 0
        let totalHeight = contentHeight + indicatorHeight + view.safeAreaInsets.bottom

        containerView.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(0)
        }

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.dimView.alpha = 1
            self?.view.layoutIfNeeded()
        }
    }

    private func hideBottomSheet(completion: (() -> Void)? = nil) {
        let indicatorHeight: CGFloat = configuration.showIndicator ? 24 : 0
        let totalHeight = contentHeight + indicatorHeight + view.safeAreaInsets.bottom

        containerView.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(totalHeight)
        }

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { [weak self] in
            self?.dimView.alpha = 0
            self?.view.layoutIfNeeded()
        } completion: { _ in
            completion?()
        }
    }

    // MARK: - Actions

    @objc private func dimViewTapped() {
        dismissBottomSheet()
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)

        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                containerView.transform = CGAffineTransform(translationX: 0, y: translation.y)
                let progress = translation.y / contentHeight
                dimView.alpha = max(0, 1 - progress)
            }

        case .ended:
            if translation.y > contentHeight * 0.3 || velocity.y > 500 {
                dismissBottomSheet()
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
                    self?.containerView.transform = .identity
                    self?.dimView.alpha = 1
                }
            }

        default:
            break
        }
    }

    // MARK: - Public Methods

    public func dismissBottomSheet() {
        hideBottomSheet { [weak self] in
            self?.dismiss(animated: false)
        }
    }

    public func updateContentHeight(_ height: CGFloat) {
        self.contentHeight = height

        let indicatorHeight: CGFloat = configuration.showIndicator ? 24 : 0
        let totalHeight = height + indicatorHeight + view.safeAreaInsets.bottom

        containerView.snp.updateConstraints {
            $0.height.equalTo(totalHeight)
        }

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
