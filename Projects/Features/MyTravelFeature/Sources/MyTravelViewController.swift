//
//  MyTravelViewController.swift
//  MyTravelFeature
//
//  Created by 최안용 on 2/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol MyTravelPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MyTravelViewController: UIViewController, MyTravelPresentable, MyTravelViewControllable {

    weak var listener: MyTravelPresentableListener?
}
