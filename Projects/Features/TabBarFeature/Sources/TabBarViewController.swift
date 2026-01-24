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
import SnapKit
import Then

// MARK: - TabBarPresentableListener

protocol TabBarPresentableListener: AnyObject {
    // ViewController에서 Interactor로 전달할 이벤트 정의
}

// MARK: - TabBarViewController

public final class TabBarViewController: UITabBarController, TabBarPresentable, TabBarViewControllable {
    // MARK: - Properties

    weak var listener: TabBarPresentableListener?

    private let disposeBag = DisposeBag()
    private var tabViewControllers: [UIViewController] = []
    private let tabTypes: [TabBarItemType] = [.information, .home, .myTrip]

    // MARK: - UI Components

    private let customTabBarContainer = UIVisualEffectView()
    private let tabStackView = UIStackView()
    private let indicatorView = UIVisualEffectView()
    private var tabItems: [NDGLTabItem] = []

    // MARK: - Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupBaseTabBar()
        setStyle()
        setUI()
        setLayout()
    }
    
    public func setViewControllers(_ viewControllers: [ViewControllable]) {
        guard let homeVC = viewControllers.first?.uiviewController else { return }
        let infoDummy = UIViewController().then { $0.view.backgroundColor = .yellow }
        let myTripDummy = UIViewController().then { $0.view.backgroundColor = .green }
        
        let finalControllers = [infoDummy, homeVC, myTripDummy]
        
        super.setViewControllers(finalControllers, animated: false)
        
        setupTabItems()
    }
}

private extension TabBarViewController {
    func setupBaseTabBar() {
        self.tabBar.isHidden = true
    }
    
    func setupTabItems() {
        tabItems.forEach { $0.removeFromSuperview() }
        tabItems.removeAll()
        
        TabBarItemType.allCases.forEach { tabType in
            let item = NDGLTabItem().then {
                $0.setup(title: tabType.title, image: tabType.image)
                $0.tag = tabType.rawValue
                $0.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
            }
            tabItems.append(item)
            tabStackView.addArrangedSubview(item)
        }

        DispatchQueue.main.async {
            self.updateSelection(at: 1, animated: false)
        }
    }
    
    func setStyle() {
        customTabBarContainer.do {
            if #available(iOS 26.0, *) {
                let glass = UIGlassEffect(style: .regular)
                glass.isInteractive = true
                glass.tintColor = .white.withAlphaComponent(0.1)
                $0.effect = glass
            } else {
                $0.effect = UIBlurEffect(style: .extraLight)
            }
            $0.layer.cornerRadius = 34.adjustedH
            $0.clipsToBounds = true
            $0.backgroundColor = .clear
        }
        
        tabStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 4
        }
        
        indicatorView.do {
            if #available(iOS 26.0, *) {
                let glass = UIGlassEffect(style: .regular)
                glass.isInteractive = true
                glass.tintColor = UIColor.NDGL.Text.primary
                $0.effect = glass
            } else {
                $0.effect = UIBlurEffect(style: .dark)
            }
            
            $0.layer.cornerRadius = 28.adjustedH
            $0.clipsToBounds = true
            $0.backgroundColor = .clear
        }
    }
    
    func setUI() {
        view.addSubview(customTabBarContainer)
        customTabBarContainer.contentView.addSubviews(indicatorView, tabStackView)
    }
    
    func setLayout() {
        customTabBarContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(328.adjusted)
            $0.height.equalTo(68.adjustedH)
        }
        
        tabStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(12)
            $0.directionalVerticalEdges.equalToSuperview().inset(6)
        }
        
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(56.adjusted)
        }
    }
    
    @objc func tabTapped(_ sender: NDGLTabItem) {
        updateSelection(at: sender.tag)
    }
    
    func updateSelection(at index: Int, animated: Bool = true) {
        self.selectedIndex = index
        let targetItem = tabItems[index]
        
        tabItems.enumerated().forEach { tabIndex, item in
            item.isTabSelected = (tabIndex == index)
        }

        let duration = animated ? 0.4 : 0.0
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.indicatorView.snp.remakeConstraints {
                $0.center.equalTo(targetItem)
                $0.width.equalTo(targetItem.snp.width)
                $0.height.equalTo(56.adjustedH)
            }
            
            self.customTabBarContainer.contentView.layoutIfNeeded()
        }
        
        if animated {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}
