//
//  HomeViewController.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core
import Domain
import DSKit
import UIKit
import RIBs
import RxSwift
import SnapKit
import Then

// MARK: - HomeViewController

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {

    // MARK: - Properties

    weak var listener: HomePresentableListener?

    private let disposeBag = DisposeBag()

    // MARK: - UI Components

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInset.bottom = 79
    }

    private let contentView = UIView()

    private let loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }

    private let myTravelView = MyTravelView()

    private let followGuideLabel = UILabel().then {
        $0.setText(.subTitleLSB, text: "인기 여행 따라가기", color: .NDGL.Text.primary)
    }

    private let categoryCollectionView = CategoryCollectionView()

    private let youtuberContentCollectionView = YoutuberContentCollectionView()

    private let showOtherTravelButton = UIButton().then {
        $0.setTitle("여행 따라가기 더보기", for: .normal)
        $0.setTitleColor(UIColor.NDGL.Text.secondary, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        $0.backgroundColor = UIColor.NDGL.Bg.primary
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor(hexCode: "#D9D9D9").cgColor
    }

    private let recommendContentGuideLabel = UILabel().then {
        $0.setText(.subTitleLSB, text: "OOO님께 추천하는\n따라가기 여행 콘텐츠에요!", color: .NDGL.Text.primary)
        $0.numberOfLines = 2
    }

    private let recommendContentCollectionView = RecommendContentCollectionView()

    private let addFloatingButton = UIButton().then {
        $0.backgroundColor = UIColor.NDGL.Bg.Interactive.primary
        $0.layer.cornerRadius = 28
        $0.setImage(DSKitAsset.Assets.icPlus2.image, for: .normal)
        $0.tintColor = .white
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupActions()
        setupUI()
        setupConstraints()
    }

    // MARK: - Setup

    private func setupDelegates() {
        categoryCollectionView.categoryDelegate = self
        youtuberContentCollectionView.contentDelegate = self
        recommendContentCollectionView.contentDelegate = self
    }

    private func setupActions() {
        showOtherTravelButton.addTarget(self, action: #selector(showOtherTravelButtonTapped), for: .touchUpInside)
        addFloatingButton.addTarget(self, action: #selector(addFloatingButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func showOtherTravelButtonTapped() {
        listener?.didTapShowMoreTrips()
    }

    @objc private func addFloatingButtonTapped() {
        listener?.didTapAddButton()
    }
}

// MARK: - HomePresentable

extension HomeViewController {
    func updateMyTrips(_ trips: [Domain.MyTrip]) {
        
    }
    
    func updateCategories(_ categories: [TripCategory], selectedIndex: Int) {
        let categoryNames = categories.map { $0.rawValue }
        categoryCollectionView.applySnapshot(categories: categoryNames, selectedIndex: selectedIndex)
    }


    func updatePopularTrips(_ tripsByCategory: [TripCategory: [PopularTrip]], categories: [TripCategory]) {
        youtuberContentCollectionView.applySnapshot(tripsByCategory: tripsByCategory, categories: categories)
    }

    func updateRecommendations(_ recommendations: [Recommendation]) {
        recommendContentCollectionView.applySnapshot(recommendations: recommendations)
    }

    func scrollToCategory(at index: Int) {
        youtuberContentCollectionView.scrollToCategory(at: index, animated: true)
    }

    func showLoading() {
        loadingIndicator.startAnimating()
    }

    func hideLoading() {
        loadingIndicator.stopAnimating()
    }
}

// MARK: - UI Setup

extension HomeViewController {
    private func setupUI() {
        view.backgroundColor = .white
        [scrollView, loadingIndicator, addFloatingButton].forEach {
            view.addSubview($0)
        }
        scrollView.addSubview(contentView)

        [myTravelView, followGuideLabel, categoryCollectionView, youtuberContentCollectionView, showOtherTravelButton, recommendContentGuideLabel, recommendContentCollectionView].forEach {
            contentView.addSubview($0)
        }

    }

    private func setupConstraints() {
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        myTravelView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(80)
        }
        followGuideLabel.snp.makeConstraints {
            $0.top.equalTo(myTravelView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(28)
        }
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(followGuideLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(36)
        }
        youtuberContentCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(288)
        }
        showOtherTravelButton.snp.makeConstraints {
            $0.top.equalTo(youtuberContentCollectionView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(40)
        }
        recommendContentGuideLabel.snp.makeConstraints {
            $0.top.equalTo(showOtherTravelButton.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(24)
        }
        recommendContentCollectionView.snp.makeConstraints {
            $0.top.equalTo(recommendContentGuideLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(260)
            $0.bottom.equalToSuperview().offset(-20)
        }
        addFloatingButton.snp.makeConstraints {
            $0.size.equalTo(56)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-70)
        }
    }
}

// MARK: - CategoryCollectionViewDelegate

extension HomeViewController: CategoryCollectionViewDelegate {
    func categoryCollectionView(_ collectionView: CategoryCollectionView, didSelectCategoryAt index: Int) {
        listener?.didSelectCategory(at: index)
    }
}

// MARK: - YoutuberContentCollectionViewDelegate

extension HomeViewController: YoutuberContentCollectionViewDelegate {
    func youtuberContentCollectionView(_ collectionView: YoutuberContentCollectionView, didSelectItemAt index: Int, in section: Int) {
        listener?.didSelectPopularTrip(at: index, in: section)
    }

    func youtuberContentCollectionView(_ collectionView: YoutuberContentCollectionView, didScrollToSection section: Int) {
        listener?.didScrollToCategory(at: section)
    }
}

// MARK: - RecommendContentCollectionViewDelegate

extension HomeViewController: RecommendContentCollectionViewDelegate {
    func recommendContentCollectionView(_ collectionView: RecommendContentCollectionView, didSelectItemAt index: Int) {
        listener?.didSelectRecommendation(at: index)
    }
}
