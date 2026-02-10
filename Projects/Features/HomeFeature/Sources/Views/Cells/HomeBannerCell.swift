//
//  HomeBannerCell.swift
//  HomeFeature
//
//  Created by 최안용 on 2/3/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

final class HomeBannerCell: UICollectionViewCell {
    static let defaultWidth = 327.adjusted
    
    private var type: HomeBannerType = .empty
    
    private let emptyView = HomeBannerEmptyView()
    private let upCommingView = HomeBannerUpCommingView()
    private let onGoingView = HomeBannerOnGoingView()
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
        
        [emptyView, upCommingView, onGoingView].forEach { $0.isHidden = true }
        
        upCommingView.prepareForReuse()
        onGoingView.prepareForReuse()
    }
    
    func configure(_ model: HomePresentationModel.Banner) {
        [emptyView, upCommingView, onGoingView].forEach { $0.isHidden = true }
        
        if model.tripSchedule.isEmpty {
            self.type = .empty
            emptyView.isHidden = false
            return
        }

        let now = Date()
        let calendar = Calendar.current
        
        let startOfToday = calendar.startOfDay(for: now)
        let startOfTravel = calendar.startOfDay(for: model.startDay)
        let startOfEnd = calendar.startOfDay(for: model.endDay)
        let dateRangeString = formatDateRange(start: model.startDay, end: model.endDay)

        if startOfToday >= startOfTravel && startOfToday <= startOfEnd {
            let schedule = model.tripSchedule.first
            
            self.type = .onGoing(
                title: model.title,
                date: dateRangeString,
                transportIcon: DSKitAsset.Assets.icBus2.image,
                duration: "\(schedule?.estimatedDuration ?? 0)분",
                place: schedule?.placeName ?? "",
                imageUrl: schedule?.thumbnailUrl ?? ""
            )
            onGoingView.isHidden = false
            
        }

        else if startOfToday < startOfTravel {
            let dDayValue = calendar.dateComponents([.day], from: startOfToday, to: startOfTravel).day ?? 0
            
            self.type = .upComming(
                title: model.title,
                date: dateRangeString,
                dDay: dDayValue,
                imageUrl: model.tripSchedule.first?.thumbnailUrl ?? ""
            )
            upCommingView.isHidden = false
        }

        else {
            self.type = .empty
            emptyView.isHidden = false
        }

        updateViewWithCurrentType()
    }
}

private extension HomeBannerCell {
    func formatDateRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        
        let startStr = formatter.string(from: start)
        let endStr = formatter.string(from: end)
        
        return "\(startStr) ~ \(endStr)"
    }
    
    func updateViewWithCurrentType() {
        switch type {
        case .upComming(let title, let date, let dDay, let imageUrl):
            upCommingView.configure(title: title, date: date, dDay: dDay, imageUrl: imageUrl)
        case .onGoing(let title, let date, let transportIcon, let duration, let place, let imageUrl):
            onGoingView.configure(
                title: title,
                date: date,
                transportIcon: transportIcon,
                transport: "대중교통",
                duration: duration,
                place: place,
                imageUrl: imageUrl
            )
        case .empty:
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
        stackView.addArrangedSubviews(emptyView, upCommingView, onGoingView)
    }
    
    func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

enum HomeBannerType: Hashable {
    case empty
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
