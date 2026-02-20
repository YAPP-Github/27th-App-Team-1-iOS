//
//  SettingInteractor.swift
//  SettingFeature
//
//  Created by 최안용 on 2/9/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs
import RxSwift

public protocol SettingRouting: ViewableRouting {
    
}

public protocol SettingPresentable: Presentable {
    var listener: SettingPresentableListener? { get set }
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
            print("FAQ")
        case .recommendLink:
            print("추천 링크")
        case .identificationCode:
            print("내 식별코드")
        case .terms:
            print("서비스 약관")
        case .personalInformation:
            print("개인정보")
        default: break
        }
    }
}
