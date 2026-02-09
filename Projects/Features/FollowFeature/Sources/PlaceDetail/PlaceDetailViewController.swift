//
//  PlaceDetailViewController.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-02-09.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs
import UIKit

// MARK: - PlaceDetailViewController

final class PlaceDetailViewController: UIViewController, PlaceDetailPresentable, PlaceDetailViewControllable {

    // MARK: - Properties

    weak var listener: PlaceDetailPresentableListener?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            listener?.didTapBackButton()
        }
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .white
    }
}
