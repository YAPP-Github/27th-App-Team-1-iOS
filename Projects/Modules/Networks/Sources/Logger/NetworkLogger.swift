//
//  NetworkLogger.swift
//  Networks
//
//  Created by kimnahun on 1/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import Moya

enum NetworkLogger {

    static func logRequest(_ target: TargetType) {
        #if DEBUG
        print("──────────────────────────────────────")
        print("[REQUEST] \(target.method.rawValue) \(target.baseURL)\(target.path)")
        if let body = requestBody(from: target.task) {
            print("[BODY] \(body)")
        }
        print("──────────────────────────────────────")
        #endif
    }

    static func logResponse(_ response: Response) {
        #if DEBUG
        let statusCode = response.statusCode
        let url = response.request?.url?.absoluteString ?? ""

        print("──────────────────────────────────────")
        print("[RESPONSE] \(statusCode) \(url)")
        if let json = try? JSONSerialization.jsonObject(with: response.data),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print("[DATA]\n\(prettyString)")
        }
        print("──────────────────────────────────────")
        #endif
    }

    static func logError(_ error: MoyaError) {
        #if DEBUG
        print("──────────────────────────────────────")
        print("[ERROR] \(error.localizedDescription)")
        print("──────────────────────────────────────")
        #endif
    }

    private static func requestBody(from task: Moya.Task) -> String? {
        switch task {
        case .requestParameters(let parameters, _):
            return parameters.description
        case .requestJSONEncodable(let encodable):
            if let data = try? JSONEncoder().encode(AnyEncodable(encodable)),
               let string = String(data: data, encoding: .utf8) {
                return string
            }
            return nil
        default:
            return nil
        }
    }
}

private struct AnyEncodable: Encodable {
    private let encode: (Encoder) throws -> Void

    init<T: Encodable>(_ value: T) {
        encode = value.encode
    }

    func encode(to encoder: Encoder) throws {
        try encode(encoder)
    }
}
