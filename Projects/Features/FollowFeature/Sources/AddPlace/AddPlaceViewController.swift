//
//  AddPlaceViewController.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-02-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import DSKit
import MapKit
import RIBs
import RxSwift
import SnapKit
import Then
import UIKit

// MARK: - AddPlaceViewController

final class AddPlaceViewController: UIViewController, AddPlacePresentable, AddPlaceViewControllable {

    // MARK: - Properties

    weak var listener: AddPlacePresentableListener?

    private let disposeBag = DisposeBag()
    private var currentAnnotation: MKAnnotation?

    // MARK: - UI Components

    private let mapView = MKMapView()

    private let searchBar = NDGLSearchBar(
        placeholder: "장소를 검색해 보세요",
        DSKitAsset.Assets.icChevronLeft3.image,
        DSKitAsset.Assets.icSearch2.image
    )

    private let resultCardView = UIView().then {
        $0.backgroundColor = UIColor(hexCode: "#FFFFFF")
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: -4)
        $0.layer.shadowRadius = 8
        $0.isHidden = true
    }

    private let placeNameLabel = UILabel()
    private let placeAddressLabel = UILabel()

    private let bottomContainerView = UIView().then {
        $0.backgroundColor = UIColor(hexCode: "#FFFFFF")
    }

    private let addButton = BottomPlacedButton(title: "일정 추가하기")

    private let loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
        $0.color = UIColor(hexCode: "#111111")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupBindings()
        setAddButtonEnabled(false)
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(searchBar)
        view.addSubview(bottomContainerView)
        bottomContainerView.addSubview(resultCardView)
        resultCardView.addSubview(placeNameLabel)
        resultCardView.addSubview(placeAddressLabel)
        bottomContainerView.addSubview(addButton)
        view.addSubview(loadingIndicator)
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        bottomContainerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }

        resultCardView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }

        placeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }

        placeAddressLabel.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }

        addButton.snp.makeConstraints {
            $0.top.equalTo(resultCardView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(52)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }

        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func setupBindings() {
        searchBar.leadingButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.listener?.didTapBack()
            }
            .disposed(by: disposeBag)

        searchBar.searchButtonClicked
            .subscribe(with: self) { owner, _ in
                // handled via searchBar.searchText on return key
            }
            .disposed(by: disposeBag)

        searchBar.searchText
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .subscribe(with: self) { owner, keyword in
                owner.listener?.search(keyword: keyword)
            }
            .disposed(by: disposeBag)

        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    @objc private func addButtonTapped() {
        listener?.didTapAddButton()
    }

    // MARK: - AddPlacePresentable

    func showResult(_ result: PlaceSearchResult) {
        // Update map
        if let existing = currentAnnotation {
            mapView.removeAnnotation(existing)
        }

        let coordinate = CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = result.name
        mapView.addAnnotation(annotation)
        currentAnnotation = annotation

        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: true)

        // Update result card
        placeNameLabel.setText(.bodyLSB, text: result.name, color: UIColor(hexCode: "#111111"))
        placeAddressLabel.setText(.bodySR, text: result.address, color: UIColor(hexCode: "#757575"))
        resultCardView.isHidden = false
    }

    func showNoResults() {
        resultCardView.isHidden = true
        if let existing = currentAnnotation {
            mapView.removeAnnotation(existing)
            currentAnnotation = nil
        }
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }

    func setAddButtonEnabled(_ enabled: Bool) {
        addButton.isUserInteractionEnabled = enabled
        addButton.alpha = enabled ? 1.0 : 0.4
    }
}
