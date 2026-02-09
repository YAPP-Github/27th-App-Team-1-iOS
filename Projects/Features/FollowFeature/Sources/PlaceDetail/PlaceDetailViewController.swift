//
//  PlaceDetailViewController.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-02-09.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import DSKit
import Kingfisher
import RIBs
import SnapKit
import UIKit

// MARK: - PlaceDetailViewController

final class PlaceDetailViewController: UIViewController, PlaceDetailPresentable, PlaceDetailViewControllable {

    // MARK: - Properties

    weak var listener: PlaceDetailPresentableListener?
    private var segmentOriginY: CGFloat = .greatestFiniteMagnitude

    // MARK: - UI Components (Fixed Header)

    private let fixedHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let reviewCountLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    // MARK: - UI Components (Sticky Header)

    private let stickyHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()

    private let stickySegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["정보", "사진"])
        control.selectedSegmentIndex = 0
        control.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        control.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        control.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        control.setTitleTextAttributes([
            .foregroundColor: UIColor(hexCode: "#999999"),
            .font: UIFont.NDGL.bodyLM.font
        ], for: .normal)
        control.setTitleTextAttributes([
            .foregroundColor: UIColor(hexCode: "#1E1E1E"),
            .font: UIFont.NDGL.bodyLSB.font
        ], for: .selected)
        return control
    }()

    private let stickyUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "#1E1E1E")
        return view
    }()

    // MARK: - UI Components (Scroll)

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let contentView = UIView()

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = UIColor(hexCode: "#F5F5F5")
        return imageView
    }()

    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["정보", "사진"])
        control.selectedSegmentIndex = 0
        control.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        control.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        control.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        control.setTitleTextAttributes([
            .foregroundColor: UIColor(hexCode: "#999999"),
            .font: UIFont.NDGL.bodyLM.font
        ], for: .normal)
        control.setTitleTextAttributes([
            .foregroundColor: UIColor(hexCode: "#1E1E1E"),
            .font: UIFont.NDGL.bodyLSB.font
        ], for: .selected)
        return control
    }()

    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "#1E1E1E")
        return view
    }()

    private let infoContainerView = UIView()
    private let photoCollectionView: PhotoCollectionView = {
        let collectionView = PhotoCollectionView()
        collectionView.isHidden = true
        return collectionView
    }()

    private let addressInfoView = PlaceInfoRowView(
        icon: DSKitAsset.Assets.icPin1.image,
        iconColor: DSKitAsset.Colors.green500.color
    )
    private let phoneInfoView = PlaceInfoRowView(
        icon: DSKitAsset.Assets.icPhone1.image,
        iconColor: DSKitAsset.Colors.green500.color
    )
    private let durationInfoView = PlaceInfoRowView(
        icon: DSKitAsset.Assets.icClock1.image,
        iconColor: DSKitAsset.Colors.green500.color
    )

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = DSKitAsset.Colors.black200.color
        return view
    }()

    // MARK: - Tip Section

    private let tipCollectionView = TipCollectionView()

    // PageControl is OUTSIDE the cells, visually overlapping but not scrolling with them
    private let tipPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor(hexCode: "#4D4D4D")
        pageControl.pageIndicatorTintColor = UIColor(hexCode: "#CCCCCC")
        pageControl.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()

    // MARK: - Plan B Section

    private let planBHeaderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private let planBCollectionView = PlanBCollectionView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupDelegates()
        setupActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            listener?.didTapBackButton()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentOriginY = segmentedControl.frame.origin.y
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(fixedHeaderView)
        [nameLabel, ratingLabel, reviewCountLabel].forEach { fixedHeaderView.addSubview($0) }

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [thumbnailImageView, segmentedControl, underlineView,
         infoContainerView, photoCollectionView, separatorView,
         tipCollectionView, tipPageControl, planBHeaderLabel, planBCollectionView].forEach {
            contentView.addSubview($0)
        }

        [addressInfoView, phoneInfoView, durationInfoView].forEach {
            infoContainerView.addSubview($0)
        }

        view.addSubview(stickyHeaderView)
        [stickySegmentedControl, stickyUnderlineView].forEach { stickyHeaderView.addSubview($0) }
    }

    private func setupConstraints() {
        fixedHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-16)
        }

        reviewCountLabel.snp.makeConstraints {
            $0.leading.equalTo(ratingLabel.snp.trailing).offset(3)
            $0.centerY.equalTo(ratingLabel)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(fixedHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }

        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }

        underlineView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(2)
        }

        infoContainerView.snp.makeConstraints {
            $0.top.equalTo(underlineView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
        }

        photoCollectionView.snp.makeConstraints {
            $0.top.equalTo(underlineView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0)
        }

        addressInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        phoneInfoView.snp.makeConstraints {
            $0.top.equalTo(addressInfoView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }

        durationInfoView.snp.makeConstraints {
            $0.top.equalTo(phoneInfoView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        separatorView.snp.makeConstraints {
            $0.top.equalTo(infoContainerView.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(1)
        }

        tipCollectionView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(218)
        }

        tipPageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(tipCollectionView.snp.bottom).offset(-20)
        }

        planBHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(tipCollectionView.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }

        planBCollectionView.snp.makeConstraints {
            $0.top.equalTo(planBHeaderLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(0)
            $0.bottom.equalToSuperview().offset(-40)
        }

        // Sticky Header
        stickyHeaderView.snp.makeConstraints {
            $0.top.equalTo(fixedHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(46)
        }

        stickySegmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }

        stickyUnderlineView.snp.makeConstraints {
            $0.top.equalTo(stickySegmentedControl.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(2)
        }
    }

    private func setupDelegates() {
        scrollView.delegate = self
        tipCollectionView.tipDelegate = self
    }

    private func setupActions() {
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        stickySegmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }

    // MARK: - Actions

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        let isInfoSelected = sender.selectedSegmentIndex == 0

        infoContainerView.isHidden = !isInfoSelected
        separatorView.isHidden = !isInfoSelected
        tipCollectionView.isHidden = !isInfoSelected
        tipPageControl.isHidden = !isInfoSelected
        planBHeaderLabel.isHidden = !isInfoSelected
        planBCollectionView.isHidden = !isInfoSelected

        photoCollectionView.isHidden = isInfoSelected

        if isInfoSelected {
            photoCollectionView.snp.remakeConstraints {
                $0.top.equalTo(underlineView.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(photoCollectionView.calculateTotalHeight())
            }
        } else {
            // Photo tab: add bottom constraint to photoCollectionView
            photoCollectionView.snp.remakeConstraints {
                $0.top.equalTo(underlineView.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(photoCollectionView.calculateTotalHeight())
                $0.bottom.equalToSuperview().offset(-40)
            }
        }

        segmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex
        stickySegmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex

        UIView.animate(withDuration: 0.2) {
            let offset = isInfoSelected ? 0 : self.view.frame.width / 2
            self.underlineView.snp.updateConstraints {
                $0.leading.equalToSuperview().offset(offset)
            }
            self.stickyUnderlineView.snp.updateConstraints {
                $0.leading.equalToSuperview().offset(offset)
            }
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - PlaceDetailPresentable

    func updatePlaceInfo(viewModel: PlaceDetailViewModel) {
        let nameAttributedText = NSAttributedString(
            string: viewModel.name,
            attributes: UIFont.NDGL.titleMSB.attributes
        )
        nameLabel.attributedText = nameAttributedText

        if let rating = viewModel.rating {
            var ratingAttributes = UIFont.NDGL.bodyMM.attributes
            ratingAttributes[.foregroundColor] = UIColor(hexCode: "#314158")
            let ratingText = NSAttributedString(
                string: "리뷰 \(String(format: "%.1f", rating))",
                attributes: ratingAttributes
            )
            ratingLabel.attributedText = ratingText
            ratingLabel.isHidden = false
        } else {
            ratingLabel.isHidden = true
        }

        if let reviewCount = viewModel.reviewCount {
            var countAttributes = UIFont.NDGL.bodyMM.attributes
            countAttributes[.foregroundColor] = DSKitAsset.Colors.black300.color
            let countText = NSAttributedString(
                string: "(\(reviewCount.formatted()))",
                attributes: countAttributes
            )
            reviewCountLabel.attributedText = countText
            reviewCountLabel.isHidden = false
        } else {
            reviewCountLabel.isHidden = true
        }

        // Thumbnail
        if let thumbnailURL = viewModel.thumbnailURL, let url = URL(string: thumbnailURL) {
            thumbnailImageView.kf.setImage(with: url)
        }

        // Info section
        if let address = viewModel.address, !address.isEmpty {
            addressInfoView.configure(text: address)
            addressInfoView.isHidden = false
        } else {
            addressInfoView.isHidden = true
        }

        if let phone = viewModel.phoneNumber, !phone.isEmpty {
            phoneInfoView.configure(text: phone)
            phoneInfoView.isHidden = false
        } else {
            phoneInfoView.isHidden = true
        }

        if let duration = viewModel.estimatedDuration {
            let hours = duration / 60
            let minutes = duration % 60
            let durationText: String
            if hours > 0 && minutes > 0 {
                durationText = "\(hours)시간 \(minutes)분 체류 예상"
            } else if hours > 0 {
                durationText = "\(hours)시간 체류 예상"
            } else {
                durationText = "\(minutes)분 체류 예상"
            }
            durationInfoView.configure(text: durationText)
            durationInfoView.isHidden = false
        } else {
            durationInfoView.isHidden = true
        }

        if !viewModel.youtubeTips.isEmpty {
            tipCollectionView.isHidden = false
            tipCollectionView.applySnapshot(tips: viewModel.youtubeTips, youtuberName: viewModel.youtuberName)
            tipPageControl.isHidden = false
            tipPageControl.numberOfPages = viewModel.youtubeTips.count
            tipPageControl.currentPage = 0
        } else {
            tipCollectionView.isHidden = true
            tipPageControl.isHidden = true
        }

        if !viewModel.planBItems.isEmpty {
            planBHeaderLabel.isHidden = false
            planBCollectionView.isHidden = false

            let planBText = NSAttributedString(
                string: "아래에서 플랜 B를 알아봐요!",
                attributes: UIFont.NDGL.bodyLSB.attributes
            )
            planBHeaderLabel.attributedText = planBText

            planBCollectionView.applySnapshot(planBItems: viewModel.planBItems)
        } else {
            planBHeaderLabel.isHidden = true
            planBCollectionView.isHidden = true
        }

        if !viewModel.placePhotos.isEmpty {
            photoCollectionView.applySnapshot(photos: viewModel.placePhotos)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.photoCollectionView.layoutIfNeeded()
                let photoHeight = self.photoCollectionView.calculateTotalHeight()
                self.photoCollectionView.snp.updateConstraints {
                    $0.height.equalTo(photoHeight)
                }
            }
        }

        let planBHeight = planBCollectionView.calculateHeight(for: viewModel.planBItems.count)
        updateBottomConstraints(
            hasTips: !viewModel.youtubeTips.isEmpty,
            hasPlanB: !viewModel.planBItems.isEmpty,
            planBHeight: planBHeight
        )
    }
}

// MARK: - Constraint Updates

private extension PlaceDetailViewController {

    func updateBottomConstraints(hasTips: Bool, hasPlanB: Bool, planBHeight: CGFloat) {
        separatorView.snp.remakeConstraints {
            $0.top.equalTo(infoContainerView.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(1)
        }

        if hasPlanB && hasTips {
            tipCollectionView.snp.remakeConstraints {
                $0.top.equalTo(separatorView.snp.bottom).offset(20)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(218)
            }
            tipPageControl.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(tipCollectionView.snp.bottom).offset(-20)
            }
            planBHeaderLabel.snp.remakeConstraints {
                $0.top.equalTo(tipCollectionView.snp.bottom).offset(32)
                $0.centerX.equalToSuperview()
            }
            planBCollectionView.snp.remakeConstraints {
                $0.top.equalTo(planBHeaderLabel.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(planBHeight)
                $0.bottom.equalToSuperview().offset(-40)
            }
        } else if hasPlanB {
            tipCollectionView.snp.remakeConstraints {
                $0.top.equalTo(separatorView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(0)
            }
            tipPageControl.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(tipCollectionView.snp.bottom)
            }
            planBHeaderLabel.snp.remakeConstraints {
                $0.top.equalTo(separatorView.snp.bottom).offset(32)
                $0.centerX.equalToSuperview()
            }
            planBCollectionView.snp.remakeConstraints {
                $0.top.equalTo(planBHeaderLabel.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(planBHeight)
                $0.bottom.equalToSuperview().offset(-40)
            }
        } else if hasTips {
            tipCollectionView.snp.remakeConstraints {
                $0.top.equalTo(separatorView.snp.bottom).offset(20)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(218)
                $0.bottom.equalToSuperview().offset(-40)
            }
            tipPageControl.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(tipCollectionView.snp.bottom).offset(-20)
            }
            planBHeaderLabel.snp.remakeConstraints {
                $0.top.equalTo(tipCollectionView.snp.bottom)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(0)
            }
            planBCollectionView.snp.remakeConstraints {
                $0.top.equalTo(planBHeaderLabel.snp.bottom)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(0)
            }
        } else {
            separatorView.snp.remakeConstraints {
                $0.top.equalTo(infoContainerView.snp.bottom).offset(25)
                $0.leading.trailing.equalToSuperview().inset(25)
                $0.height.equalTo(1)
                $0.bottom.equalToSuperview().offset(-40)
            }
            tipCollectionView.snp.remakeConstraints {
                $0.top.equalTo(separatorView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(0)
            }
            tipPageControl.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(tipCollectionView.snp.bottom)
            }
            planBHeaderLabel.snp.remakeConstraints {
                $0.top.equalTo(separatorView.snp.bottom)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(0)
            }
            planBCollectionView.snp.remakeConstraints {
                $0.top.equalTo(separatorView.snp.bottom)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(0)
            }
        }

        view.layoutIfNeeded()
    }
}

// MARK: - UIScrollViewDelegate

extension PlaceDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let segmentHeight: CGFloat = 44
        let underlineHeight: CGFloat = 2
        let threshold = segmentOriginY + segmentHeight + underlineHeight
        stickyHeaderView.isHidden = offsetY < threshold
    }
}

// MARK: - TipCollectionViewDelegate

extension PlaceDetailViewController: TipCollectionViewDelegate {

    func tipCollectionView(_ collectionView: TipCollectionView, didScrollToPage page: Int) {
        tipPageControl.currentPage = page
        listener?.didScrollToTipPage(page)
    }
}

