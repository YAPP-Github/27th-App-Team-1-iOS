//
//  TravelToolViewController.swift
//  TravelToolFeature
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs
import UIKit

// MARK: - TravelToolViewController

final class TravelToolViewController: UIViewController, TravelToolPresentable, TravelToolViewControllable {

    // MARK: - Properties

    weak var listener: TravelToolPresentableListener?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
