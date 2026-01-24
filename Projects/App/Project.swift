//
//  Project.swift
//  27th-App-Team-1-iOSManifests
//
//  Created by 최안용 on 1/13/26.
//

import ProjectDescription
import ProjectDescriptionHelpers
import EnvPlugin
import DependencyPlugin
import ConfigPlugin


let project = Project.makeModule(
    name: "App",
    targets: [
        .makeAppTarget(
            name: "App",
            infoPlist:  Project.appInfoPlist,
            scripts: [.swiftLint],
            dependencies: [
                .data,
                .Modules.networks,
                .Features.rootFeature,
            ],
            settings: .appSettings()
        )
    ]
)
