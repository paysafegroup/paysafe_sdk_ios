//
//  ThreeDSecureService.swift
//  Paysafe_SDK
//
//  Created by Tsvetelina Stoyanova on 12.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation
import CardinalMobile

@objcMembers public class ThreeDSecureService: NSObject {
    private var onChallengeCompleted: ((Result<String, Error>) -> Void)?

    private let logger: LoggerProtocol
    private let webServiceHandler: ThreeDSecureWebServiceProtocol
    private let cardinalSessionFactoryMethod: () -> CardinalSessionProtocol

    private var responseDict: [String: Any]?
    private var challengePayload: ChallengePayload?
    private var merchantConfiguration: PaysafeSDK.MerchantConfiguration?

    private lazy var correlationId: String = {
        return generateCorrelationId()
    }()

    private lazy var session: CardinalSessionProtocol = initializeCardinalSession()

    private func initializeCardinalSession() -> CardinalSessionProtocol {
        let session = cardinalSessionFactoryMethod()
        let config = CardinalSessionConfiguration()
        var sessionEnvironment: CardinalSessionEnvironment = .production

        if PaysafeSDK.currentEnvironment == .test {
            sessionEnvironment = .staging
        }

        config.deploymentEnvironment = sessionEnvironment
        config.requestTimeout = CardinalSessionTimeoutStandard
        config.uiType = .both

        if let customUI = PaysafeSDK.uiConfiguration?.createCustomizedObject() {
            config.uiCustomization = customUI
        }

        config.renderType = [CardinalSessionRenderTypeOTP, CardinalSessionRenderTypeHTML]
        config.enableDFSync = true
        session.configure(config)

        return session
    }

    private enum Constants {
        static let threeDSecurePath = "/threedsecure/v2"
    }

    public convenience override init() {
        self.init(merchantConfiguration: nil)
    }

    /**
     - Parameter merchantConfiguration: The merchant's configuration that would be used.
        If you don't need different merchantConfiguration for every call, you can set a static one via PaysafeSDK.merchantConfiguration.
     **/
    public convenience init(merchantConfiguration: PaysafeSDK.MerchantConfiguration? = nil) {
        let localMerchantConfiguration = merchantConfiguration ?? PaysafeSDK.merchantConfiguration

        let loggingUrl = ThreeDSecureService.getThreeDSecureBasePath() + "/log"
        let localLogger = Logger(logUrl: loggingUrl,
                                 merchantConfiguration: localMerchantConfiguration)

        self.init(merchantConfiguration: localMerchantConfiguration,
                  logger: localLogger,
                  webServiceHandler: ThreeDSecureWebService(merchantConfiguration: localMerchantConfiguration),
                  cardinalSessionFactoryMethod: {
                    return CardinalSession()
        })
    }

    init(merchantConfiguration: PaysafeSDK.MerchantConfiguration?,
         logger: LoggerProtocol,
         webServiceHandler: ThreeDSecureWebServiceProtocol,
         cardinalSessionFactoryMethod: @escaping () -> CardinalSessionProtocol) {
        self.merchantConfiguration = merchantConfiguration
        self.logger = logger
        self.webServiceHandler = webServiceHandler
        self.cardinalSessionFactoryMethod = cardinalSessionFactoryMethod
    }

    private func generateCorrelationId() -> String {
        return UUID().uuidString.lowercased()
    }

    private func getJWTForCardinal(cardBin: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let merchantConfiguration = self.merchantConfiguration else {
            completion(.failure(Errors.invalidMerchantConfigurationError))
            return
        }

        let sdkInfo = PaysafeSDK.sdkInfo
        let requestInfo = ThreeDSecureJWTRequestParameters(accountId: merchantConfiguration.accountId,
                                                           cardBin: cardBin,
                                                           sdkInfo: sdkInfo)
        webServiceHandler.getJWTToken(with: requestInfo,
                                      correlationId: correlationId,
                                      completion: { [weak self] (result: Result<ThreeDSecureJWTResponse, Error>) in
                                        self?.didRecieveJWT(result, completion: completion)
        })
    }

    private func didRecieveJWT(_ result: Result<ThreeDSecureJWTResponse, Error>,
                               completion: @escaping (Result<String, Error>) -> Void) {
        switch result {
        case let .failure(error):
            completion(.failure(error))
        case let .success(response):
            initializeCardinalWith(response: response,
                                   completion: completion)
        }
    }

    private func callFinalize(validateResponse: CardinalResponse?,
                              accountID: String,
                              threeDSecureAuthID: String,
                              serverJWT: String?) {

        let payload = serverJWT == "" ? nil : serverJWT
        let requestData = ThreeDSecureFinalizeRequestParameters(payload: payload)

        let finalizeCorrelationId = correlationId

        webServiceHandler.finalize(accountID: accountID,
                                   threeDSecureAuthID: threeDSecureAuthID,
                                   correlationId: correlationId,
                                   with: requestData,
                                   completion: { [weak self] (result: Result<Data, Error>) in

                                    guard let onChallengeCompleted = self?.onChallengeCompleted else {
                                        return
                                    }

                                    if let validateResponse = validateResponse,
                                        validateResponse.actionCode == .error {
                                        let errorMessage = "Error occurred during challenge for authentication: \(threeDSecureAuthID) failed with \(validateResponse.debugDescription)"
                                        self?.logger.log(message: errorMessage, eventType: .internalSDKError, correlationId: finalizeCorrelationId)
                                    }

                                    switch result {
                                    case .failure(let error):
                                        onChallengeCompleted(.failure(error))

                                    case .success:
                                        onChallengeCompleted(.success(threeDSecureAuthID))
                                    }
        })
    }

    private func initializeCardinalWith(response: ThreeDSecureJWTResponse, completion: @escaping (Result<String, Error>) -> Void) {
        initializeCardinalWith(jwtString: response.jwt,
                               completion: { initializeCardinalResult in
                                switch initializeCardinalResult {
                                case let .failure(error):
                                    completion(.failure(error))
                                case .success:
                                    completion(.success(response.deviceFingerprintingId))
                                }
        })
    }

    private func initializeCardinalWith(jwtString: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let initializeCorrelationId = correlationId
        session.setup(jwtString: jwtString,
                      completed: { [weak self] _ in
                        self?.logger.log(message: "DeviceFingerPrinting completed successfully", eventType: .success, correlationId: initializeCorrelationId)
                        completion(.success(()))
                        },
                      validated: { [weak self] _ in
                        self?.logger.log(message: "DeviceFingerPrinting failed with: \(Errors.ErrorType.internalSDKError)",
                            eventType: .internalSDKError,
                            correlationId: initializeCorrelationId)
                        completion(.failure(Errors.internalSDKError))
        })
    }

    private static func getThreeDSecureBasePath() -> String {
        let result = PaysafeSDK.getBaseUrlPath() + Constants.threeDSecurePath
        return result
    }
}

extension ThreeDSecureService: CardinalValidationDelegate {
    public func cardinalSession(cardinalSession session: CardinalSession?, stepUpValidated validateResponse: CardinalResponse?, serverJWT: String?) {
        guard let challengePayload = challengePayload else {
            logger.log(message: Errors.ErrorType.internalSDKError, eventType: .internalSDKError, correlationId: correlationId)
            onChallengeCompleted?(.failure(Errors.internalSDKError))
            return
        }

        if let validateResponse = validateResponse,
            validateResponse.isValidated {
            logger.log(message: "Challenge for authentication: \(challengePayload.id) passed", eventType: .success, correlationId: correlationId)
        }

        callFinalize(validateResponse: validateResponse,
                     accountID: challengePayload.accountId,
                     threeDSecureAuthID: challengePayload.id,
                     serverJWT: serverJWT)
    }
}

extension ThreeDSecureService {
    /**
     - Parameters:
     - result: Result of the query, or `nil` if an error occurred.
     - error: An error that indicates why the query failed, or `nil` if it was succesful.
     */
    public typealias Callback = (_ result: String?, _ error: Error?) -> Void

    /**
     Initializes device fingerprinting procedure.

     - Parameters:
        - cardBin: BIN of the card that will be used for transaction. Usually between minimum = 6, maximum = 8 digits.
        - completion: Invoked when request failed or completed. Returns *device fingerprinting ID* if operation
        passes successfully or error otherwise.

     - Precondition: `cardBin` must be between 6 and 8 digits.
     */
    public func start(cardBin: String, completion: @escaping Callback) {
        start(cardBin: cardBin,
              completion: { result in
                switch result {
                case let .failure(error):
                    completion(nil, error)
                case let .success(deviceFingerprintId):
                    completion(deviceFingerprintId, nil)
                }
        })
    }

    /**
     Handles 3DS challenge flow if required.

     - Parameters:
        - sdkChallengePayload: SDK challenge payload returned by the call to the `/authentications` endpoint. It is *base64* encoded string.
        - completion: A closure that is called when query results are available or when an error occurs. \
        If successful returns **authenticationId** of the current authentication or error otherwise.
     */
    public func challenge(sdkChallengePayload: String, completion: @escaping Callback) {
        challenge(sdkChallengePayload: sdkChallengePayload,
                  completion: { result in
                    switch result {
                    case let .failure(error):
                        completion(nil, error)
                    case let .success(authenticationId):
                        completion(authenticationId, nil)
                    }
        })
    }

    /**
     - Parameter result: `Result<String, Error>` object where
        * `String` represents successful result of the query, or `nil` if an error occurred.
        * `Error` represents an error that indicates why the query failed, or `nil` if query was succesful.
     */
    public typealias ResultCallback = (_ result: Result<String, Error>) -> Void

    /**
     Initializes device fingerprinting procedure.

     - Parameters:
        - cardBin: BIN of the card that will be used for transaction. Usually between minimum = 6, maximum = 8 digits.
        - completion: Invoked when request failed or completed. It returns `Result<String, Error>` object
        with *device fingerprinting ID* if operation passes successfully or error otherwise.

     - Precondition: `cardBin` must be between 6 and 8 digits.
     */
    public func start(cardBin: String, completion: @escaping ResultCallback) {
        correlationId = generateCorrelationId()
        getJWTForCardinal(cardBin: cardBin,
                          completion: completion)
    }

    /**
     Handles 3DS challenge flow if required.

     - Parameters:
        - sdkChallengePayload: SDK challenge payload returned by the call to the `/authentications` endpoint. It is *base64* encoded string.
        - completion: A closure that is called when query results are available or when an error occurs. \
        If successful returns `Result<String, Error>` object with **authenticationId** of the current authentication or error otherwise.
     */
    public func challenge(sdkChallengePayload: String, completion: @escaping ResultCallback) {
        guard let challengePayload = ChallengePayload.challenge(from: sdkChallengePayload) else {
            logger.log(message: Errors.ErrorType.invalidOptions + "sdkChallengePayload", eventType: .validationError, correlationId: correlationId)
            completion(.failure(Errors.invalidOptions("sdkChallengePayload")))
            return
        }

        onChallengeCompleted = completion
      
        self.challengePayload = challengePayload

        session.continueWith(transactionId: challengePayload.transactionId,
                             payload: challengePayload.payload,
                             validationDelegate: self)

    }

}
