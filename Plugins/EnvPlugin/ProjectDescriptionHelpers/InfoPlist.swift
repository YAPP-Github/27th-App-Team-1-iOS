//
//  InfoPlist.swift
//  27th-App-Team-1-iOSManifests
//
//  Created by 최안용 on 1/13/26.
//

import ProjectDescription

public extension Project {
    static let appInfoPlist: [String: Plist.Value] = [
        "CFBundleShortVersionString": .string("1.0.0"),
        "CFBundleDevelopmentRegion": .string("ko"),
        "CFBundleVersion": .string("1"),
        "UIUserInterfaceStyle": "Light",
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "CFBundleIdentifier": .string("\(Environment.bundleId).App"),
        "CFBundleDisplayName": .string("$(APP_DISPLAY_NAME)"),
        "UILaunchStoryboardName": .string("LaunchScreen"),
        "UIApplicationSceneManifest": .dictionary([
                "UIApplicationSupportsMultipleScenes": .boolean(false),
                "UISceneConfigurations": .dictionary([
                    "UIWindowSceneSessionRoleApplication": .array([
                        .dictionary([
                            "UISceneConfigurationName": .string("Default Configuration"),
                            "UISceneDelegateClassName": .string("$(PRODUCT_MODULE_NAME).SceneDelegate")
                        ])
                    ])
                ])
        ]),
        "NSAppTransportSecurity": .dictionary([
            "NSAllowsArbitraryLoads": .boolean(true)
        ]),
        "ITSAppUsesNonExemptEncryption": .boolean(false),
        "BASE_URL": .string("$(BASE_URL)"),
        "X_API_KEY": .string("$(X_API_KEY)"),
        "GOOGLE_WEATHER_API_KEY": .string("$(GOOGLE_WEATHER_API_KEY)")
    ]

    static let demoInfoPlist: [String: Plist.Value] = [
        "CFBundleShortVersionString": .string("1.0.0"),
        "CFBundleDevelopmentRegion": .string("ko"),
        "CFBundleVersion": .string("1"),
        "UIUserInterfaceStyle": "Light",
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "CFBundleIdentifier": .string("\(Environment.bundleId)"),
        "CFBundleDisplayName": .string("$(APP_DISPLAY_NAME)"),
        "UILaunchStoryboardName": .string("LaunchScreen"),
        "UIApplicationSceneManifest": .dictionary([
            "UIApplicationSupportsMultipleScenes": .boolean(false),
            "UISceneConfigurations": .dictionary([
                "UIWindowSceneSessionRoleApplication": .array([
                    .dictionary([
                        "UISceneConfigurationName": .string("Default Configuration"),
                        "UISceneDelegateClassName": .string("$(PRODUCT_MODULE_NAME).SceneDelegate")
                    ])
                ])
            ])
        ]),
        "NSAppTransportSecurity": .dictionary([
            "NSAllowsArbitraryLoads": .boolean(true)
        ]),
        "ITSAppUsesNonExemptEncryption": .boolean(false),
        "BASE_URL": .string("$(BASE_URL)")
    ]

    static let framework: InfoPlist = .extendingDefault(with: [
        "CFBundlePackageType": "FMWK"
    ])
}
