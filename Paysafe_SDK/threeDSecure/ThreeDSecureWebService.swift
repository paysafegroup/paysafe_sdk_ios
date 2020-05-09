//
//  ThreeDSecureWebService.swift
//  Paysafe_SDK
//
//  Created by Ivelin Davidov on 14.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

protocol ThreeDSecureWebServiceProtocol {
    func getJWTToken(
        with payload: ThreeDSecureJWTRequestParameters,
        correlationId: String,
        completion: @escaping (Result<ThreeDSecureJWTResponse, Error>) -> Void)

    func finalize(
        accountID: String,
        threeDSecureAuthID: String,
        correlationId: String,
        with payload: ThreeDSecureFinalizeRequestParameters,
        completion: @escaping (Result<Data, Error>) -> Void)
}

class ThreeDSecureWebService: ThreeDSecureWebServiceProtocol {
    private enum Constants {
        static let threeDSecurePath = "/threedsecure/v2"
    }

    private let webServiceHandler: WebServiceHandler

    init(merchantConfiguration: PaysafeSDK.MerchantConfiguration?) {
        webServiceHandler = WebServiceHandler(merchantConfiguration: merchantConfiguration)
    }

    func getJWTToken(
        with payload: ThreeDSecureJWTRequestParameters,
        correlationId: String,
        completion: @escaping (Result<ThreeDSecureJWTResponse, Error>) -> Void) {

        var baseURL = getThreeDSecureBasePath()
        baseURL.append("/jwt")

        webServiceHandler.callWebService(with: baseURL,
                                         requestData: payload,
                                         method: .post,
                                         correlationId: correlationId,
                                         completion: completion)
    }

    func finalize(
        accountID: String,
        threeDSecureAuthID: String,
        correlationId: String,
        with payload: ThreeDSecureFinalizeRequestParameters, completion: @escaping (Result<Data, Error>) -> Void) {

        var baseURL = getThreeDSecureBasePath()
        baseURL.append("/accounts/\(accountID)/authentications/\(threeDSecureAuthID)/finalize")

        webServiceHandler.callWebService(with: baseURL,
                                         requestData: payload,
                                         method: .post,
                                         correlationId: correlationId,
                                         completion: completion)
    }

    private func getThreeDSecureBasePath() -> String {
        let result = PaysafeSDK.getBaseUrlPath() + Constants.threeDSecurePath
        return result
    }

}
