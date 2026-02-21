//
//  TravelToolViewController.swift
//  TravelToolFeature
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs
import UIKit

import DSKit

// MARK: - TravelToolViewController

final class TravelToolViewController: UIViewController, TravelToolPresentable, TravelToolViewControllable {

    // MARK: - Properties

    weak var listener: TravelToolPresentableListener?

    // MARK: - UI

    private let tripCardView = TravelToolTripCardView()

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
}

// MARK: - Private

private extension TravelToolViewController {
    func setStyle() {
        view.backgroundColor = .white
    }

    func setUI() {
        view.addSubview(tripCardView)
    }

    func setLayout() {
        tripCardView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24.adjusted)
        }
    }
}
