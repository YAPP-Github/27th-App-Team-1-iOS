//
//  HomeViewController.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import RIBs
import RxSwift
import SnapKit
import Then

// MARK: - HomePresentableListener

protocol HomePresentableListener: AnyObject {
    // ViewController에서 Interactor로 전달할 이벤트 정의
}

// MARK: - HomeViewController

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {

    // MARK: - Properties

    weak var listener: HomePresentableListener?

    private let disposeBag = DisposeBag()

    // MARK: - UI Components

    private let titleLabel = UILabel().then {
        $0.text = "Home"
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .black
        $0.textAlignment = .center
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
