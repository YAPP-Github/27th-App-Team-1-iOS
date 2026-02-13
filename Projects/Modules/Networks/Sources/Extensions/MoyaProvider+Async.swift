//
//  MoyaProvider+Async.swift
//  Networks
//
//  Created by kimnahun on 1/19/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation
import Moya

extension MoyaProvider {
    private static var successCode: String { "2000" }

    func request<T: Decodable & Sendable, E: Error & Sendable>(
        _ target: Target,
        errorMapper: @escaping @Sendable (String, String, [ErrorResponse.ErrorDetail]) -> E
    ) async -> NetworkResult<T, E> {
        NetworkLogger.logRequest(target)

        return await withCheckedContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    NetworkLogger.logResponse(response)

                    do {
                        let baseResponse = try JSONDecoder().decode(
                            BaseResponse<T>.self,
                            from: response.data
                        )

                        if baseResponse.code == Self.successCode {
                            guard let data = baseResponse.data else {
                                continuation.resume(returning: .networkFailure(.decodingFailed))
                                return
                            }
                            continuation.resume(returning: .success(data))
                        } else {
                            let errorResponse = try JSONDecoder().decode(
                                ErrorResponse.self,
                                from: response.data
                            )
                            let apiError = errorMapper(
                                errorResponse.code ?? "",
                                errorResponse.message ?? "",
                                errorResponse.errors ?? []
                            )
                            continuation.resume(returning: .failure(apiError))
                        }
                    } catch {
                        continuation.resume(returning: .networkFailure(.decodingFailed))
                    }

                case .failure(let moyaError):
                    NetworkLogger.logError(moyaError)
                    let networkError = Self.mapMoyaError(moyaError)
                    continuation.resume(returning: .networkFailure(networkError))
                }
            }
        }
    }

    func requestPlain<E: Error & Sendable>(
        _ target: Target,
        errorMapper: @escaping @Sendable (String, String, [ErrorResponse.ErrorDetail]) -> E
    ) async -> NetworkResult<Void, E> {
        NetworkLogger.logRequest(target)

        return await withCheckedContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    NetworkLogger.logResponse(response)

                    do {
                        let baseResponse = try JSONDecoder().decode(
                            BaseResponse<EmptyResponse>.self,
                            from: response.data
                        )

                        if baseResponse.code == Self.successCode {
                            continuation.resume(returning: .success(()))
                        } else {
                            let errorResponse = try JSONDecoder().decode(
                                ErrorResponse.self,
                                from: response.data
                            )
                            let apiError = errorMapper(
                                errorResponse.code ?? "",
                                errorResponse.message ?? "",
                                errorResponse.errors ?? []
                            )
                            continuation.resume(returning: .failure(apiError))
                        }
                    } catch {
                        continuation.resume(returning: .networkFailure(.decodingFailed))
                    }

                case .failure(let moyaError):
                    NetworkLogger.logError(moyaError)
                    let networkError = Self.mapMoyaError(moyaError)
                    continuation.resume(returning: .networkFailure(networkError))
                }
            }
        }
    }
    
    func asyncThowsRequest<T: Decodable>(_ target: Target) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            NetworkLogger.logRequest(target)
            
            request(target) { result in
                switch result {
                case .success(let response):
                    NetworkLogger.logResponse(response)
                    
                    guard (200...299).contains(response.statusCode) else {
                        let error = (try? response.map(ErrorResponse.self))
                            .map { NetworkError.serverError($0) }
                        ?? NetworkError.unknown("Status Code: \(response.statusCode)")
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    do {
                        let baseResponse = try response.map(BaseResponse<T>.self)
                        if let data = baseResponse.data {
                            continuation.resume(returning: data)
                        } else {
                            continuation.resume(throwing: NetworkError.noData)
                        }
                    } catch {
                        continuation.resume(throwing: NetworkError.decodingFailed)
                    }
                case .failure(let error):
                    NetworkLogger.logError(error)
                    continuation.resume(throwing: NetworkError.unknown(error.localizedDescription))
                }
            }
        }
    }
    
    private static func mapMoyaError(_ error: MoyaError) -> NetworkError {
        switch error {
        case .underlying(let nsError as NSError, _)
            where nsError.domain == NSURLErrorDomain:
            return .connectionFailed
        default:
            return .unknown(error.localizedDescription)
        }
    }
}
