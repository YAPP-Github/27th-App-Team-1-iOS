//
//  Toast.swift
//  DSKit
//
//  Created by 최안용 on 2/20/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

public final class Toast {
    public static func show(
        type: NDGLToastView.ToastType,
        message: String,
        bottomPadding: CGFloat
    ) {
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
        guard let window = scene.windows.first(where: { $0.isKeyWindow }) else { return }
                
        let previousToast = window.subviews.first { $0 is NDGLToastView }
        previousToast?.removeFromSuperview()
        
        let toast = NDGLToastView(type: type, message: message)
        toast.isUserInteractionEnabled = false
        toast.alpha = 0.0
        
        window.addSubview(toast)
        
        toast.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(window.safeAreaLayoutGuide).inset(bottomPadding.adjustedH)
            $0.width.greaterThanOrEqualTo(327.adjusted)
            $0.height.greaterThanOrEqualTo(46.adjustedH)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
            toast.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 1.0, options: .curveEaseOut, animations: {
                toast.alpha = 0.0
            }) { _ in
                toast.removeFromSuperview()
            }
        })
    }
}
