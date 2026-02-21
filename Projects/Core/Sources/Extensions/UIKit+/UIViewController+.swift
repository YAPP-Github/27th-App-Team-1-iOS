//
//  UIViewController+.swift
//  Core
//
//  Created by 최안용 on 2/18/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

public extension UIViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
