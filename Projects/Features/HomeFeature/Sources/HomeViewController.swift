//
//  HomeViewController.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import UIKit

import RIBs
import RxSwift
import SnapKit
import Then

// MARK: - HomePresentableListener

protocol HomePresentableListener: AnyObject {
    func didSelectCategory(_ category: TripCategory)
    func didTapRefresh()
}

// MARK: - HomeViewController

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {

    // MARK: - Properties

    weak var listener: HomePresentableListener?

    private let disposeBag = DisposeBag()
    private var myTrips: [MyTrip] = []
    private var popularTrips: [PopularTrip] = []
    private var recommendations: [Recommendation] = []
    private var selectedCategory: TripCategory = .all

    // MARK: - UI Components

    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }

    private let contentView = UIView()

    private let loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }

    // 내가 등록한 여행지 섹션
    private let myTripsHeaderLabel = UILabel().then {
        $0.text = "내가 등록한 여행지"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .black
    }

    private lazy var myTripsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 180)
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MyTripCell.self, forCellWithReuseIdentifier: MyTripCell.identifier)
        collectionView.dataSource = self
        return collectionView
    }()

    // 인기 여행 따라가기 섹션
    private let popularTripsHeaderLabel = UILabel().then {
        $0.text = "인기 여행 따라가기"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .black
    }

    private lazy var categoryScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }

    private lazy var categoryStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }

    private lazy var popularTripsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 220)
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PopularTripCell.self, forCellWithReuseIdentifier: PopularTripCell.identifier)
        collectionView.dataSource = self
        return collectionView
    }()

    // 추천 따라하기 콘텐츠 섹션
    private let recommendationsHeaderLabel = UILabel().then {
        $0.text = "추천 따라하기 콘텐츠"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .black
    }

    private lazy var recommendationsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 250, height: 200)
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(RecommendationCell.self, forCellWithReuseIdentifier: RecommendationCell.identifier)
        collectionView.dataSource = self
        return collectionView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupCategoryButtons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentInset.bottom = 70
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)

        scrollView.addSubview(contentView)

        [myTripsHeaderLabel, myTripsCollectionView,
         popularTripsHeaderLabel, categoryScrollView, popularTripsCollectionView,
         recommendationsHeaderLabel, recommendationsCollectionView].forEach {
            contentView.addSubview($0)
        }

        categoryScrollView.addSubview(categoryStackView)
    }

    private func setupConstraints() {
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        // 내가 등록한 여행지
        myTripsHeaderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
        }

        myTripsCollectionView.snp.makeConstraints {
            $0.top.equalTo(myTripsHeaderLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(180)
        }

        // 인기 여행 따라가기
        popularTripsHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(myTripsCollectionView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }

        categoryScrollView.snp.makeConstraints {
            $0.top.equalTo(popularTripsHeaderLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(36)
        }

        categoryStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }

        popularTripsCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryScrollView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(220)
        }

        // 추천 따라하기 콘텐츠
        recommendationsHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(popularTripsCollectionView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }

        recommendationsCollectionView.snp.makeConstraints {
            $0.top.equalTo(recommendationsHeaderLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
            $0.bottom.equalToSuperview()
        }
    }

    private func setupCategoryButtons() {
        categoryScrollView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let categories: [TripCategory] = [.all, .japan, .vietnam, .europe, .hongkong, .singapore]

        categories.forEach { category in
            let button = UIButton(type: .system)
            button.setTitle(category.rawValue, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemBlue.cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            button.tag = categories.firstIndex(of: category) ?? 0
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)

            if category == selectedCategory {
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(.systemBlue, for: .normal)
            }

            categoryStackView.addArrangedSubview(button)
        }
    }

    @objc private func categoryButtonTapped(_ sender: UIButton) {
        let categories: [TripCategory] = [.all, .japan, .vietnam, .europe, .hongkong, .singapore]
        let category = categories[sender.tag]
        selectedCategory = category

        // 버튼 UI 업데이트
        categoryStackView.arrangedSubviews.forEach { view in
            guard let button = view as? UIButton else { return }
            if button.tag == sender.tag {
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(.systemBlue, for: .normal)
            }
        }

        listener?.didSelectCategory(category)
    }

    // MARK: - HomePresentable

    func updateMyTrips(_ trips: [MyTrip]) {
        self.myTrips = trips
        myTripsCollectionView.reloadData()
    }

    func updatePopularTrips(_ trips: [PopularTrip]) {
        self.popularTrips = trips
        popularTripsCollectionView.reloadData()
    }

    func updateRecommendations(_ recommendations: [Recommendation]) {
        self.recommendations = recommendations
        recommendationsCollectionView.reloadData()
    }

    func showLoading() {
        loadingIndicator.startAnimating()
        scrollView.isHidden = true
    }

    func hideLoading() {
        loadingIndicator.stopAnimating()
        scrollView.isHidden = false
    }

}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case myTripsCollectionView:
            return myTrips.count
        case popularTripsCollectionView:
            return popularTrips.count
        case recommendationsCollectionView:
            return recommendations.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case myTripsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyTripCell.identifier,
                for: indexPath
            ) as? MyTripCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: myTrips[indexPath.item])
            return cell

        case popularTripsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PopularTripCell.identifier,
                for: indexPath
            ) as? PopularTripCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: popularTrips[indexPath.item])
            return cell

        case recommendationsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendationCell.identifier,
                for: indexPath
            ) as? RecommendationCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: recommendations[indexPath.item])
            return cell

        default:
            return UICollectionViewCell()
        }
    }
}
