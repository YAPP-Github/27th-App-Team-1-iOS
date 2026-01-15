//
//  Environment.swift
//  27th-App-Team-1-iOSManifests
//
//  Created by 최안용 on 1/13/26.
//

import ProjectDescription

public enum Environment {
    public static let workspaceName = "NDGL-iOS"
    public static let deploymentTarget = "17.0"
    public static let bundleId = "org.yapp.NDGL"
    
    public struct App {
        public static let displayName = "나도갈래"
        public static let version = "1.0.0"
        public static let buildNumber = "1"
    }
}

public extension Project {
    enum Environment {
        public static let organizationName = "NDGL-iOS"
        public static let deploymentTarget = DeploymentTargets.iOS("17.0")
        public static let bundleId = "org.yapp.NDGL"
        public static let appName = "NDGL"
    }
}
