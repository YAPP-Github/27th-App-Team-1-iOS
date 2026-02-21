//
//  SettingInteractor.swift
//  SettingFeature
//
//  Created by 최안용 on 2/9/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core

import RIBs
import RxSwift

public protocol SettingRouting: ViewableRouting {
    
}

public protocol SettingPresentable: Presentable {
    var listener: SettingPresentableListener? { get set }
    
    func copyToClipboard()
}

public protocol SettingListener: AnyObject {
    func detachSetting()
}

final class SettingInteractor: PresentableInteractor<SettingPresentable>, SettingInteractable, SettingPresentableListener {
    weak var router: SettingRouting?
    weak var listener: SettingListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SettingPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func detachSetting() {
        // 부모 RIB에게 이 화면을 닫아달라고 알림
        listener?.detachSetting()
    }
    
    func didTapMenu(item: SettingCellItem) {
        // 각 메뉴 타이틀에 따른 동작 처리
        switch item {
//        case .notification:
//            print("알림")
        case .faq:
            URLHelper.openURL("https://repeated-tapir-33f.notion.site/FAQ-30ccbdc5a38380d6af4af7b7c412921e?source=copy_link")
        case .recommendLink:
            URLHelper.openURL("https://forms.gle/3q1uhQVeeKRrz11y5")
        case .identificationCode:
            presenter.copyToClipboard()
        case .terms:
            URLHelper.openURL("https://repeated-tapir-33f.notion.site/2c8cbdc5a3838070a8d8ccdcd0631c9a?source=copy_link")
        case .personalInformation:
            URLHelper.openURL("https://repeated-tapir-33f.notion.site/30ccbdc5a38380e3a50ace64a9b0f398?source=copy_link")
        default: break
        }
    }
}
