//
//  HomeVC.swift
//  HomeFeature
//
//  Created by 최안용 on 1/15/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

import BaseFeatureDependency

// Coordinator 도입시 public 제거 후 Coordinator 클래스를 통해 접근
public final class HomeVC: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
