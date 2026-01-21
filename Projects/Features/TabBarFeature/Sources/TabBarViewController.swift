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

public final class TabBarViewController: UIViewController, TabBarPresentable, TabBarViewControllable {

    // MARK: - Properties

    weak var listener: TabBarPresentableListener?

    private let disposeBag = DisposeBag()
    private var tabViewControllers: [UIViewController] = []
    private var selectedIndex: Int = 0

    // MARK: - UI Components

    private let containerView = UIView()

    private let customTabBarView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 28
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: -2)
        $0.layer.shadowRadius = 10
    }

    private let tabStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .center
        $0.spacing = 0
    }

    private lazy var planTabButton = createTabButton(
        icon: "doc.text",
        title: "일정",
        tag: 0
    )

    private lazy var homeTabButton = createTabButton(
        icon: "house.fill",
        title: "홈",
        tag: 1,
        isSelected: true
    )

    private lazy var myTabButton = createTabButton(
        icon: "bag",
        title: "내 여행",
        tag: 2
    )

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        updateTabSelection(index: 1)
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(containerView)
        view.addSubview(customTabBarView)

        customTabBarView.addSubview(tabStackView)
        [planTabButton, homeTabButton, myTabButton].forEach {
            tabStackView.addArrangedSubview($0)
        }
    }

    private func setupConstraints() {
        // 컨텐츠가 탭바 뒤로도 스크롤되도록 전체 화면으로 설정
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        customTabBarView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }

        tabStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func createTabButton(icon: String, title: String, tag: Int, isSelected: Bool = false) -> UIView {
        let containerView = UIView()
        containerView.tag = tag

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false

        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = isSelected ? .white : .gray

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = isSelected ? .white : .gray
        label.isHidden = !isSelected

        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(label)

        containerView.addSubview(stackView)

        iconView.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        if isSelected {
            let backgroundView = UIView()
            backgroundView.backgroundColor = .black
            backgroundView.layer.cornerRadius = 20
            backgroundView.tag = 100
            containerView.insertSubview(backgroundView, at: 0)
            backgroundView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.height.equalTo(40)
                $0.width.equalTo(stackView.snp.width).offset(32)
            }
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabButtonTapped(_:)))
        containerView.addGestureRecognizer(tapGesture)

        return containerView
    }

    @objc private func tabButtonTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedView = gesture.view else { return }
        let index = tappedView.tag
        updateTabSelection(index: index)
        showViewController(at: index)
    }

    private func updateTabSelection(index: Int) {
        selectedIndex = index
        let buttons = [planTabButton, homeTabButton, myTabButton]

        buttons.enumerated().forEach { idx, button in
            let isSelected = idx == index
            let stackView = button.subviews.first { $0 is UIStackView } as? UIStackView
            let iconView = stackView?.arrangedSubviews.first as? UIImageView
            let label = stackView?.arrangedSubviews.last as? UILabel

            // 기존 배경 제거
            button.subviews.first { $0.tag == 100 }?.removeFromSuperview()

            if isSelected {
                iconView?.tintColor = .white
                label?.textColor = .white
                label?.isHidden = false

                let backgroundView = UIView()
                backgroundView.backgroundColor = .black
                backgroundView.layer.cornerRadius = 20
                backgroundView.tag = 100
                button.insertSubview(backgroundView, at: 0)
                backgroundView.snp.makeConstraints {
                    $0.center.equalToSuperview()
                    $0.height.equalTo(40)
                    $0.width.equalTo(stackView!.snp.width).offset(32)
                }
            } else {
                iconView?.tintColor = .gray
                label?.textColor = .gray
                label?.isHidden = true
            }
        }
    }

    private func showViewController(at index: Int) {
        guard index < tabViewControllers.count else { return }

        // 기존 child 제거
        children.forEach { child in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        // 새 child 추가
        let selectedVC = tabViewControllers[index]
        addChild(selectedVC)
        containerView.addSubview(selectedVC.view)
        selectedVC.view.translatesAutoresizingMaskIntoConstraints = false
        selectedVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        selectedVC.didMove(toParent: self)
    }

    // MARK: - TabBarViewControllable

    public func setViewControllers(_ viewControllers: [ViewControllable]) {
        // 3개의 VC 설정 (Home은 실제, 나머지는 placeholder)
        let homeVC = viewControllers.first?.uiviewController ?? UIViewController()

        let planVC = UIViewController()
        planVC.view.backgroundColor = .systemGray6
        let planLabel = UILabel()
        planLabel.text = "일정 (준비중)"
        planLabel.textAlignment = .center
        planVC.view.addSubview(planLabel)
        planLabel.snp.makeConstraints { $0.center.equalToSuperview() }

        let myTripVC = UIViewController()
        myTripVC.view.backgroundColor = .systemGray6
        let myLabel = UILabel()
        myLabel.text = "내 여행 (준비중)"
        myLabel.textAlignment = .center
        myTripVC.view.addSubview(myLabel)
        myLabel.snp.makeConstraints { $0.center.equalToSuperview() }

        tabViewControllers = [planVC, homeVC, myTripVC]

        // 기본으로 홈(index 1) 표시
        showViewController(at: 1)
    }
}
