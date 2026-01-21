//
//  TabBarViewController.swift
//  TabBarFeature
//
//  Created by kimnahun on 2026-01-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import RIBs
import RxSwift

// MARK: - TabBarPresentableListener

protocol TabBarPresentableListener: AnyObject {
    // ViewController에서 Interactor로 전달할 이벤트 정의
}

// MARK: - TabBarViewController

public final class TabBarViewController: UITabBarController, TabBarPresentable, TabBarViewControllable {

    // MARK: - Properties

    weak var listener: TabBarPresentableListener?

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    // MARK: - Setup

    private func setupTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
    }

    // MARK: - TabBarViewControllable

    public func setViewControllers(_ viewControllers: [ViewControllable]) {
        let uiViewControllers = viewControllers.enumerated().map { index, vc -> UIViewController in
            let viewController = vc.uiviewController

            switch index {
            case 0:
                viewController.tabBarItem = UITabBarItem(
                    title: "홈",
                    image: UIImage(systemName: "house"),
                    selectedImage: UIImage(systemName: "house.fill")
                )
            case 1:
                viewController.tabBarItem = UITabBarItem(
                    title: "검색",
                    image: UIImage(systemName: "magnifyingglass"),
                    selectedImage: UIImage(systemName: "magnifyingglass")
                )
            case 2:
                viewController.tabBarItem = UITabBarItem(
                    title: "마이",
                    image: UIImage(systemName: "person"),
                    selectedImage: UIImage(systemName: "person.fill")
                )
            default:
                break
            }

            return viewController
        }

        setViewControllers(uiViewControllers, animated: false)
    }
}
