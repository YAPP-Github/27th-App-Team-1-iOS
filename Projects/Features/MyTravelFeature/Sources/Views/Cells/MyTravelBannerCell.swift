//
//  MyTravelBannerCell.swift
//  MyTravelFeature
//
//  Created by 최안용 on 2/23/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

final class MyTravelBannerCell: UICollectionViewCell {
    static let defaultWidth = 327.adjusted
    
    private var type: MyTravelBannerType?
    
    private let upCommingView = NDGLUpComingView()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        [upCommingView, onGoingView].forEach { $0.isHidden = true }
        
        upCommingView.prepareForReuse()
        onGoingView.prepareForReuse()
    }
    
    func configure(_ model: MyTravelPresentationModel.Banner) {
        [upCommingView, onGoingView].forEach { $0.isHidden = true }
        
        let now = Date()
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: now)
        let startOfTravel = calendar.startOfDay(for: model.startDay)
        let startOfEnd = calendar.startOfDay(for: model.endDay)
        
        if startOfToday >= startOfTravel && startOfToday <= startOfEnd {
            let schedule = model.tripSchedule
            self.type = .onGoing(
                title: model.title,
                date: model.duration,
                transportIcon: DSKitAsset.Assets.icBus2.image,
                duration: "\(schedule.estimatedDuration)분",
                place: schedule.placeName,
                imageUrl: schedule.thumbnailUrl
            )
        } else {
            let dDayValue = calendar.dateComponents([.day], from: startOfToday, to: startOfTravel).day ?? 0
            self.type = .upComming(
                title: model.title,
                date: model.duration,
                dDay: dDayValue,
                imageUrl: model.tripSchedule.thumbnailUrl
            )
        }
        
        updateViewWithCurrentType()
    }
}

private extension MyTravelBannerCell {
    func updateViewWithCurrentType() {
        switch type {
        case .upComming(let title, let date, let dDay, let imageUrl):
            upCommingView.isHidden = false
            onGoingView.isHidden = true
            upCommingView.configure(title: title, date: date, dDay: dDay, imageUrl: imageUrl)
            
        case .onGoing(let title, let date, let transportIcon, let duration, let place, let imageUrl):
            onGoingView.isHidden = false
            upCommingView.isHidden = true
            onGoingView.configure(
                title: title,
                date: date,
                transportIcon: transportIcon,
                transport: "대중교통",
                duration: duration,
                place: place,
                imageUrl: imageUrl
            )
        case .none:
            break
        }
    }
    
    func setStyle() {
        contentView.do {
            $0.backgroundColor = DSKitAsset.Colors.black50.color
            $0.layer.cornerRadius = 8.adjustedH
            $0.clipsToBounds = true
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }
    
    func setUI() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews(upCommingView, onGoingView)
    }
    
    func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

enum MyTravelBannerType: Hashable {
    case upComming(title: String, date: String, dDay: Int, imageUrl: String)
    case onGoing(
        title: String,
        date: String,
        transportIcon: UIImage?,
        duration: String,
        place: String,
        imageUrl: String
    )
}
