//
//  CustomerVaultService.swift
//  Paysafe_SDK
//
//  Created by Ivelin Davidov on 12.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

@objc public class CustomerVaultService: NSObject {

    private enum Constants {
        static let createSingleUseTokenPath = "/customervault/v1/singleusetokens"
        static let createApplePaySingleUseTokenPath = "/customervault/v1/applepaysingleusetokens"
    }

    private let webServiceHandler: WebServiceHandlerProtocol

    private lazy var correlationId: String = {
        return generateCorrelationId()
    }()

    private func generateCorrelationId() -> String {
        return UUID().uuidString.lowercased()
    }

    public convenience override init() {
        self.init(merchantConfiguration: nil)
    }

    public convenience init(merchantConfiguration: PaysafeSDK.MerchantConfiguration? = nil) {
        let merchantConfiguration = merchantConfiguration ?? PaysafeSDK.merchantConfiguration
        let handler = WebServiceHandler(merchantConfiguration: merchantConfiguration)

        self.init(webServiceHandler: handler)
    }

    init(webServiceHandler: WebServiceHandlerProtocol) {
        self.webServiceHandler = webServiceHandler
    }

    @objc public func createSingleUseToken(card: Card, completion: @escaping (SingleUseToken?, Error?) -> Void) {
        createSingleUseToken(card: card,
                             completion: { result in
                                switch result {
                                case let .success(card):
                                    completion(card, nil)
                                case let .failure(error):
                                    completion(nil, error)
                                }
        })
    }

    public func createSingleUseToken(card: Card, completion: @escaping (Result<SingleUseToken, Error>) -> Void) {
        let urlString = PaysafeSDK.getBaseUrlPath() + Constants.createSingleUseTokenPath
        let cardWrapper = CardWrapper(card: card)
        webServiceHandler.callWebService(with: urlString,
                                         requestData: cardWrapper,
                                         method: .post,
                                         correlationId: correlationId,
                                         completion: completion)
    }

    public func createApplePaySingleUseToken(_ applePayToken: ApplePayTokenWrapper, completion: @escaping (Result<ApplePaySingleUseToken, Error>) -> Void) {
        let urlString = PaysafeSDK.getBaseUrlPath() + Constants.createApplePaySingleUseTokenPath

        webServiceHandler.callWebService(with: urlString,
                                         requestData: applePayToken,
                                         method: .post,
                                         correlationId: correlationId,
                                         completion: completion)
    }

    private struct CardWrapper: Encodable {
        let card: Card
    }
}
