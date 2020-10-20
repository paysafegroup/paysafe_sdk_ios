//
//  MerchantBackend.swift
//  Example
//
//  Created by Ivelin Davidov on 18.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation
import Paysafe_SDK

// This logic is supposed to be on the Merchant's backend. For simplicity it's inside this example project.
@objc open class MerchantSampleBackend: NSObject {

    private enum Constants {
        static let threeDSecureAccountsPath = "/threedsecure/v2/accounts"
    }

    private var card: Card?
    private var service: CustomerVaultService?

    private lazy var baseUrl = {
        return PaysafeSDK.getBaseUrlPath() + Constants.threeDSecureAccountsPath
    }()

    @objc public func createApplePaymentFakeToken(cardNum: String, completion: @escaping (_ wrapper:ApplePayTokenWrapper?, _ error: Error?) -> Void) -> Void {
        createApplePaymentFakeToken(cardNum: cardNum) { result in
            switch result {
            case .success(let info):
                completion(info, nil)
            case .failure(let error):
                completion(nil, error)
            }
            
        }
    }
    
    func createApplePaymentFakeToken(cardNum: String, completion: @escaping (Result<ApplePayTokenWrapper, Error>) -> Void) -> Void {
        let customerVaultFakeTokenRequest = CustomerVaultFakeToken(cardNumber: cardNum, applicationExpirationDate: "6001", transactionAmount: "241", cardholderName: "Bil Gates")
        let webServiceHandler = WebServiceHandler()
        let url = PaysafeSDK.getBaseUrlPath() + "/customervault/v1/applepaysingleusetokens/faketoken/simple"
        webServiceHandler.callWebService(with:  url, requestData: customerVaultFakeTokenRequest, method: .post, completion:completion)
    }
    
    @objc public func startTransaction(with card: Card, completion: @escaping (_ error: Error?) -> Void) {
        startTransaction(card) { result in
            switch result {
            case .success:
                completion(nil)

            case .failure(let error):
                completion(error)
            }
        }
    }

     func startTransaction(_ card: Card, completion: @escaping (Result<Void, Error>) -> Void) {
        self.card = card
        
        service = CustomerVaultService()
        service?.createSingleUseToken(card: card,
                                     completion: { result in
                                        switch result {
                                        case let .failure(error):
                                            completion(.failure(error))
                                        case .success:
                                            completion(.success(()))
                                        }
        })
    }

    @objc public func sendApplePay(_ applePayToken: ApplePayTokenWrapper,
                                   completion: @escaping (_ response: ApplePaySingleUseToken?, _ error: Error?) -> Void) {

        sendApplePay(applePayToken) { result in
            switch result {
            case let .failure(error):
                completion(nil, error)
            case .success(let info):
                completion(info, nil)
            }
        }
    }

    func sendApplePay(_ applePayToken: ApplePayTokenWrapper,
                      completion: @escaping (Result<ApplePaySingleUseToken, Error>) -> Void) {

        service = CustomerVaultService()
        service?.createApplePaySingleUseToken(applePayToken, completion: completion)
    }

    @objc public func getChallengePayload(for amount: Int, with deviceFingerPrintId: String, completion: @escaping (_ response: AuthenticationResponse?, _ error: Error?) -> Void) {
        getChallengePayload(for: amount, with: deviceFingerPrintId) { result in
            switch result {
            case .success(let data):
                completion(data, nil)

            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    // Most of the parameters used inside these methods are hardcoded for the simplicity of the example as this logic should not be part of the mobile application, but part of the merchant's backend.
    func getChallengePayload(for amount: Int, with deviceFingerPrintId: String, completion: @escaping (Result<AuthenticationResponse, Error>) -> Void) {
        guard let card = card,
            let accountId = PaysafeSDK.merchantConfiguration?.accountId else {
            assertionFailure()
            return
        }

        let merchantAccountCurrency = "USD"
        let merchantRefNum = randomString(length: 10)
        let merchantUrl = "https://merchantWebsite.com"
        let deviceChannel = "SDK"

        let messageCategory = "PAYMENT"
        let authenticationPurpose = "PAYMENT_TRANSACTION"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let initialPurchaseTime = dateFormatter.string(from: Date())

        let payload = AuthenticationPayload(deviceFingerprintingId: deviceFingerPrintId,
                                            merchantRefNum: merchantRefNum,
                                            amount: amount,
                                            currency: merchantAccountCurrency,
                                            card: card,
                                            merchantUrl: merchantUrl,
                                            authenticationPurpose: authenticationPurpose,
                                            deviceChannel: deviceChannel,
                                            messageCategory: messageCategory,
                                            initialPurchaseTime: initialPurchaseTime)

        let url = baseUrl + "/\(accountId)/authentications"
        let webServiceHandler = WebServiceHandler()
        webServiceHandler.callWebService(with: url,
                                         requestData: payload,
                                         method: .post,
                                         completion: completion)
    }

    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in letters.randomElement() })
    }

    @objc public func authenticate(_ authenticationId: String, completion: @escaping (_ response: AuthenticationIdResponse?, _ error: Error?) -> Void) {
        authenticate(authenticationId) { result in
            switch result {
            case .success(let data):
                completion(data, nil)

            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    func authenticate(_ authenticationId: String, completion: @escaping (Result<AuthenticationIdResponse, Error>) -> Void) {
        let emptyBody: EmptyBody? = nil

        guard let accountId = PaysafeSDK.merchantConfiguration?.accountId else {
            return
        }

        let url = baseUrl + "/\(accountId)/authentications/\(authenticationId)"
        let webServiceHandler = WebServiceHandler()
        webServiceHandler.callWebService(with: url,
                                         requestData: emptyBody,
                                         method: .get,
                                         completion: completion)
    }
}

private struct AuthenticationPayload: Encodable {
    let deviceFingerprintingId: String
    let merchantRefNum: String
    let amount: Int
    let currency: String
    let card: Card
    let merchantUrl: String

    let authenticationPurpose: String
    let deviceChannel: String
    let messageCategory: String
    let initialPurchaseTime: String
}

@objcMembers public class AuthenticationResponse: NSObject, Decodable {
    let id: String
    public let sdkChallengePayload: String?
}

struct EmptyBody: Encodable {
}

public class AuthenticationIdResponse: NSObject, Decodable {
    @objc public enum ResponseStatus: Int, Decodable {
        case completed
        case pending
        case failed

        public init(from decoder: Decoder) throws {
            let singleValueContainer = try decoder.singleValueContainer()
            let value = try singleValueContainer.decode(String.self)
            switch value {
            case "COMPLETED": self = .completed
            case "PENDING": self = .pending
            case "FAILED": self = .failed
            default:
                assert(false)
                self = .failed
            }
        }

        func stringValue() -> String {
            switch self {
            case .completed:
                return "Completed"
            case .pending:
                return "Pending"
            case .failed:
                return "Failed"
            }
        }
    }

    @objc public let status: ResponseStatus
    @objc public func stringValueForCurrentStatus() -> String {
        return status.stringValue()
    }
}
