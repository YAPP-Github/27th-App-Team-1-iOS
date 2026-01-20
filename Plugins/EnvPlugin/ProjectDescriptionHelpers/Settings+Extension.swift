//
//  Settings+Extension.swift
//  EnvPlugin
//
//  Created by 최안용 on 1/13/26.
//

import ProjectDescription

public extension Settings {
    /// 프레임워크용 기본 설정
    static let frameworkSettings: Settings = .settings(
        base: [
            "SKIP_INSTALL": "YES",
            "BUILD_LIBRARY_FOR_DISTRIBUTION": "NO",
            "DEFINES_MODULE": "YES",
            "ENABLE_BITCODE": "NO",
            "IPHONEOS_DEPLOYMENT_TARGET": .string(Environment.deploymentTarget),
            "SWIFT_VERSION": "6.0",
            "CLANG_ENABLE_MODULES": "YES",
            "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
            "ENABLE_MODULE_VERIFIER": "YES",
            "MODULE_VERIFIER_SUPPORTED_LANGUAGES": "objective-c objective-c++"
        ]
    )
    
    /// 앱용 설정
    static func appSettings() -> Settings {
        let baseSettings: [String: SettingValue] = [
            "APP_NAME": .string(Environment.App.displayName),
            "APP_DISPLAY_NAME": .string(Environment.App.displayName),
            "CODE_SIGN_STYLE": "Manual",
            "DEVELOPMENT_TEAM": SettingValue(stringLiteral: "$(DEVELOPMENT_TEAM)"),
            "MARKETING_VERSION": .string(Environment.App.version),
            "CURRENT_PROJECT_VERSION": .string(Environment.App.buildNumber),
            "ENABLE_BITCODE": "NO",
            "IPHONEOS_DEPLOYMENT_TARGET": .string(Environment.deploymentTarget),
            "SWIFT_VERSION": "6.0",
            "CLANG_ENABLE_MODULES": "YES",
            "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
            "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES"
        ]
        
        let debugSettings: [String: SettingValue] = [
            "APP_DISPLAY_NAME": .string("\(Environment.App.displayName)-Dev"),
            "PRODUCT_NAME": .string("\(Environment.App.displayName)"),
            "PROVISIONING_PROFILE_SPECIFIER": SettingValue(stringLiteral: "$(APP_PROVISIONING_PROFILE)"),
            "CODE_SIGN_IDENTITY": SettingValue(stringLiteral: "$(CODE_SIGN_IDENTITY)"),
            "ENABLE_TESTABILITY": "YES",
            "GCC_OPTIMIZATION_LEVEL": "0",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
            "DEBUG_INFORMATION_FORMAT": "dwarf",
            "GCC_PREPROCESSOR_DEFINITIONS": .array(["DEBUG=1"])
        ]
        
        let releaseSettings: [String: SettingValue] = [
            "APP_DISPLAY_NAME": .string(Environment.App.displayName),
            "PRODUCT_NAME": .string("\(Environment.App.displayName)"),
            "PROVISIONING_PROFILE_SPECIFIER": SettingValue(stringLiteral: "$(APP_PROVISIONING_PROFILE)"),
            "CODE_SIGN_IDENTITY": SettingValue(stringLiteral: "$(CODE_SIGN_IDENTITY)"),
            "SWIFT_OPTIMIZATION_LEVEL": "-O",
            "ENABLE_TESTABILITY": "NO",
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "SWIFT_COMPILATION_MODE": "wholemodule"
        ]
        
        return .settings(
            base: baseSettings,
            configurations: [
                .debug(name: .debug, settings: debugSettings),
                .release(name: .release, settings: releaseSettings)
            ]
        )
    }
    
    /// 데모 앱용 설정
    static let demoAppSettings: Settings = .settings(
        base: [
            "CODE_SIGN_STYLE": "Automatic",
            "DEVELOPMENT_TEAM": SettingValue(stringLiteral: "$(DEVELOPMENT_TEAM)"),
            "IPHONEOS_DEPLOYMENT_TARGET": .string(Environment.deploymentTarget),
            "SWIFT_VERSION": "6.0",
            "ENABLE_TESTABILITY": "YES"
        ]
    )
}
