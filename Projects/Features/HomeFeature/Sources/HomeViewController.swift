//
//  HomeViewController.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import DSKit
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
        $0.contentInset.bottom = 79
    }

    private let contentView = UIView()

    private let loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }

    private let myTripView = UIView()

    private let followGuideLabel = UILabel().then {
        $0.setText(.subTitleLSB, text: "인기 여행 따라가기", color: .NDGL.Text.primary)
    }
    
    private let youtuberNameCollectionView = UIView()
    
    private let youtuberContentCollectionView = UIView()
    
    private let showOtherTravelButton = UIButton()
    
    private let recommendContentGuideLabel = UILabel().then {
        $0.setText(.subTitleLSB, text: "OOO님께 추천하는\n따라가기 여행 콘텐츠에요!", color: .NDGL.Text.primary)
        $0.numberOfLines = 2
    }
    
    private let followTripCollectionView = UIView()
    
    private let addFloadtingButton = UIButton()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension HomeViewController {
    func updateMyTrips(_ trips: [Domain.MyTrip]) {
        
    }
    
    func updatePopularTrips(_ trips: [Domain.PopularTrip]) {
        
    }
    
    func updateRecommendations(_ recommendations: [Domain.Recommendation]) {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
}

extension HomeViewController {
    private func setupUI() {
        view.backgroundColor = .white
        [scrollView, loadingIndicator, addFloadtingButton].forEach {
            view.addSubview($0)
        }
        scrollView.addSubview(contentView)

        [myTripView, followGuideLabel, youtuberNameCollectionView, youtuberContentCollectionView, showOtherTravelButton, recommendContentGuideLabel, followTripCollectionView].forEach {
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
        myTripView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.horizontalEdges.equalToSuperview().offset(24)
        }
        followGuideLabel.snp.makeConstraints {
            $0.top.equalTo(myTripView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(28)
        }
        youtuberNameCollectionView.snp.makeConstraints {
            $0.top.equalTo(followGuideLabel.snp.bottom).offset(25)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        youtuberContentCollectionView.snp.makeConstraints {
            $0.top.equalTo(youtuberNameCollectionView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(youtuberNameCollectionView)
            $0.height.equalTo(288)
        }
        showOtherTravelButton.snp.makeConstraints {
            $0.top.equalTo(youtuberContentCollectionView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().offset(24)
            $0.height.equalTo(40)
        }
        recommendContentGuideLabel.snp.makeConstraints {
            $0.top.equalTo(showOtherTravelButton.snp.bottom).offset(40)
            $0.leading.equalTo(showOtherTravelButton)
            $0.height.equalTo(56)
        }
        followTripCollectionView.snp.makeConstraints {
            $0.top.equalTo(recommendContentGuideLabel.snp.bottom).offset(24)
            $0.leading.equalTo(showOtherTravelButton)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        addFloadtingButton.snp.makeConstraints {
            $0.size.equalTo(56)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-101)
        }
    }
}
