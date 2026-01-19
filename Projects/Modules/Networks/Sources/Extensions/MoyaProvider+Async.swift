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
    
    func request<T: Decodable, E: APIErrorProtocol>(
        _ target: Target,
        errorType: E.Type
    ) async -> NetworkResult<T, E> {
        await withCheckedContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
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
                            let apiError = E(
                                code: errorResponse.code ?? "",
                                message: errorResponse.message ?? "",
                                errors: errorResponse.errors ?? []
                            )
                            continuation.resume(returning: .failure(apiError))
                        }
                    } catch {
                        continuation.resume(returning: .networkFailure(.decodingFailed))
                    }
                    
                case .failure(let moyaError):
                    let networkError = Self.mapMoyaError(moyaError)
                    continuation.resume(returning: .networkFailure(networkError))
                }
            }
        }
    }
    
    func requestPlain<E: APIErrorProtocol>(
        _ target: Target,
        errorType: E.Type
    ) async -> NetworkResult<Void, E> {
        await withCheckedContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
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
                            let apiError = E(
                                code: errorResponse.code ?? "",
                                message: errorResponse.message ?? "",
                                errors: errorResponse.errors ?? []
                            )
                            continuation.resume(returning: .failure(apiError))
                        }
                    } catch {
                        continuation.resume(returning: .networkFailure(.decodingFailed))
                    }
                    
                case .failure(let moyaError):
                    let networkError = Self.mapMoyaError(moyaError)
                    continuation.resume(returning: .networkFailure(networkError))
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
            return .unknown(error)
        }
    }
}
