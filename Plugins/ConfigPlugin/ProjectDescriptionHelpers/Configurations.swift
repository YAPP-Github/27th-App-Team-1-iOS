//
//  Configurations.swift
//  EnvPlugin
//
//  Created by 최안용 on 1/13/26.
//

import ProjectDescription

public struct XCConfig {
    public struct Path {
        static var debug: ProjectDescription.Path {
            .relativeToRoot("xcconfigs/Debug.xcconfig")
        }
        
        static var release: ProjectDescription.Path {
            .relativeToRoot("xcconfigs/Release.xcconfig")
        }
    }
    
    public static let framework: [Configuration] = [
        .debug(name: "Debug", xcconfig: Path.debug),
        .release(name: "Release", xcconfig: Path.release)
    ]
    
    public static let demo: [Configuration] = [
        .debug(name: "Debug", xcconfig: Path.debug),
        .release(name: "Release", xcconfig: Path.release)
    ]
    
    public static let prod: [Configuration] = [
        .debug(name: "Debug", xcconfig: Path.debug),
        .release(name: "Release", xcconfig: Path.release)
    ]
}
