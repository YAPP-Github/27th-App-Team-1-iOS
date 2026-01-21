//
//  RootViewController.swift
//  RootFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import RIBs
import RxSwift

// MARK: - RootPresentableListener

protocol RootPresentableListener: AnyObject {
    // ViewController에서 Interactor로 전달할 이벤트 정의
}

// MARK: - RootViewController

public final class RootViewController: UIViewController, RootPresentable, RootViewControllable {

    // MARK: - Properties

    weak var listener: RootPresentableListener?

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARK: - RootViewControllable

    public func present(viewController: ViewControllable) {
        present(viewController.uiviewController, animated: true)
    }

    public func dismiss(viewController: ViewControllable) {
        if presentedViewController === viewController.uiviewController {
            dismiss(animated: true)
        }
    }

    public func setRootViewController(_ viewController: ViewControllable) {
        let childVC = viewController.uiviewController

        addChild(childVC)
        view.addSubview(childVC.view)

        childVC.view.frame = view.bounds
        childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        childVC.didMove(toParent: self)
    }
}
