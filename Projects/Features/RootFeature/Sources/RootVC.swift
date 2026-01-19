//
//  RootVC.swift
//  RootFeature
//
//  Created by 최안용 on 1/15/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import HomeFeature


public final class RootVC: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeNavigationController = UINavigationController()
        homeNavigationController.viewControllers = [HomeVC()]
        
        addChild(homeNavigationController)
        
        view.addSubview(homeNavigationController.view)
        
        homeNavigationController.view.frame = view.bounds
        homeNavigationController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        homeNavigationController.didMove(toParent: self)
    }
}
