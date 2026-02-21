//
//  TravelToolTripCardView.swift
//  TravelToolFeature
//
//  Created by kimnahun on 2026-02-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

enum TravelToolTripState {
    case empty
    case upComing(title: String, date: String, dDay: Int, imageUrl: String)
    case onGoing(
        title: String,
        date: String,
        transportIcon: UIImage?,
        transport: String,
        duration: String,
        place: String,
        imageUrl: String
    )
}

final class TravelToolTripCardView: UIView {
    private let emptyView = TravelToolEmptyView()
    private let upComingView = NDGLUpComingView()
    private let onGoingView = NDGLOnGoingView()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ state: TravelToolTripState) {
        [emptyView, upComingView, onGoingView].forEach { $0.isHidden = true }

        switch state {
        case .empty:
            emptyView.isHidden = false
        case .upComing(let title, let date, let dDay, let imageUrl):
            upComingView.isHidden = false
            upComingView.configure(title: title, date: date, dDay: dDay, imageUrl: imageUrl)
        case .onGoing(let title, let date, let transportIcon, let transport, let duration, let place, let imageUrl):
            onGoingView.isHidden = false
            onGoingView.configure(
                title: title,
                date: date,
                transportIcon: transportIcon,
                transport: transport,
                duration: duration,
                place: place,
                imageUrl: imageUrl
            )
        }
    }
}

private extension TravelToolTripCardView {
    func setStyle() {
        backgroundColor = DSKitAsset.Colors.black50.color
        layer.cornerRadius = 8.adjustedH
        clipsToBounds = true

        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }

    func setUI() {
        addSubview(stackView)
        stackView.addArrangedSubviews(emptyView, upComingView, onGoingView)
    }

    func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
