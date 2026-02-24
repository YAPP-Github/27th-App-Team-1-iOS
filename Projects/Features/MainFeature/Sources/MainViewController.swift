//
//  MainViewController.swift
//  MainFeature
//
//  Created by 최안용 on 2/11/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import RIBs

protocol MainPresentableListener: AnyObject {
    func viewDidLoad()
}

final class MainViewController: UINavigationController, MainPresentable, MainViewControllable {
    weak var listener: MainPresentableListener?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setupDelegate()
        listener?.viewDidLoad()        
    }
    
    func setViewControllers(_ viewControllables: [ViewControllable]) {
        let viewControllers = viewControllables.map { $0.uiviewController }
        self.setViewControllers(viewControllers, animated: false)
    }
    
    func pushViewController(_ viewControllable: ViewControllable, animated: Bool) {
        self.pushViewController(viewControllable.uiviewController, animated: animated)
    }
    
    func popRootViewController(animated: Bool) {
        self.popViewController(animated: animated)
    }
    
    func containsInStack(_ viewControllable: ViewControllable) -> Bool {
        self.viewControllers.contains(viewControllable.uiviewController)
    }
    
    func showServiceNoticeModal() {
        let noticeVC = ServiceNoticeViewController()
        noticeVC.modalPresentationStyle = .overFullScreen
        noticeVC.modalTransitionStyle = .crossDissolve
        
        noticeVC.termsHandler = {
            URLHelper.openURL("https://repeated-tapir-33f.notion.site/2c8cbdc5a3838070a8d8ccdcd0631c9a?source=copy_link")
        }
        
        self.present(noticeVC, animated: true)
    }
}

private extension MainViewController {
    func setStyle() {
        self.view.backgroundColor = DSKitAsset.Colors.white.color
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    private func setupDelegate() {
        self.interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
