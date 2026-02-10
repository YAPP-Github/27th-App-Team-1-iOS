//
//  Project.swift
//  27th-App-Team-1-iOSManifests
//
//  Created by 최안용 on 1/13/26.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "ThirdPartyLibs",
    targets: [
        .makeFrameworkTarget(
            name: "ThirdPartyLibs",
            dependencies: [
                .SPM.Kingfisher,
                .SPM.Moya,
                .SPM.RIBs,
                .SPM.RxCocoa,
                .SPM.SnapKit,
                .SPM.Then
            ],
            scripts: [],
            hasResources: false
        )
    ]
)
