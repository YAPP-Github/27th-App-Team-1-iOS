//
//  Project.swift
//  27th-App-Team-1-iOSManifests
//
//  Created by 최안용 on 1/13/26.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import EnvPlugin

let project = Project.makeModule(
    name: "Networks",
    targets: [
        .makeFrameworkTarget(
            name: "Networks",
            dependencies: [
                .core,
                .domain
            ],
            scripts: [.swiftLint],
            isStatic: true,
            hasResources: false
        ),
        .target(
            name: "NetworksTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "org.yapp.NDGL.NetworksTests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "BASE_URL": .string("$(BASE_URL)")
            ]),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Networks")
            ],
            settings: .settings(configurations: [
                .debug(name: "Debug", xcconfig: .relativeToRoot("xcconfigs/Debug.xcconfig")),
                .release(name: "Release", xcconfig: .relativeToRoot("xcconfigs/Release.xcconfig"))
            ])
        )
    ]
)
