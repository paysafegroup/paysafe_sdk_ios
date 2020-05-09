//
//  ThreeDSecureServiceTests.swift
//  Paysafe_SDKTests
//
//  Created by Ivelin Davidov on 9.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation
@testable import Paysafe_SDK
import XCTest
import CardinalMobile

class ThreeDSecureServiceTests: XCTestCase {
    var mockWebService: MockWebServiceHandler!
    var mockCardinalSession: MockCardinalSession!
    var mockLogger: MockLogger!

    var service: ThreeDSecureService!

    var merchantConfiguration: PaysafeSDK.MerchantConfiguration!

    override func setUp() {
        super.setUp()

        setupMerchantConfig()

        mockLogger = MockLogger()
        mockWebService = MockWebServiceHandler()
        mockCardinalSession = MockCardinalSession()

        service = ThreeDSecureService(merchantConfiguration: merchantConfiguration,
                                      logger: mockLogger,
                                      webServiceHandler: mockWebService,
                                      cardinalSessionFactoryMethod: {
                                        return self.mockCardinalSession
        })
    }

    func testStartWithInvalidMerchantConfiguration() {
        PaysafeSDK.merchantConfiguration = nil

        let exp = expectation(description: "start completion should be called")
        
        let service = ThreeDSecureService()
        service.start(cardBin: "123456", completion: { (result) in
            let error = result.error as NSError?
            XCTAssertEqual(error, Errors.invalidMerchantConfigurationError)
            exp.fulfill()
        })

        wait(for: [exp], timeout: 0.1)
    }

    func testStartCallJWTTokenServiceReturnsError() {
        let exp = expectation(description: "start completion should be called")
        service.start(cardBin: "123456", completion: { (result) in
            let error = result.error as NSError?
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 100)
            exp.fulfill()
        })

        let error = NSError(domain: "Test Error Domain", code: 100, userInfo: nil)
        mockWebService.getJWTTokenCompletion?(.failure(error))

        wait(for: [exp], timeout: 0.1)
    }

    func testStartCallCardinalError() {
        let exp = expectation(description: "start completion should be called")
        service.start(cardBin: "123456", completion: { (result) in
            let error = result.error as NSError?
            XCTAssertEqual(error, Errors.internalSDKError)

            XCTAssertEqual(self.mockLogger.loggedMessages.count, 1)
            let loggedMessage = self.mockLogger.loggedMessages.first!
            XCTAssertEqual(loggedMessage.0, "DeviceFingerPrinting failed with: Unhandled error occurred.")
            XCTAssertEqual(loggedMessage.1, .internalSDKError)

            exp.fulfill()
        })

        let response = ThreeDSecureJWTResponse(deviceFingerprintingId: "fingerprintId",
                                               jwt: "jwt")
        mockWebService.getJWTTokenCompletion?(.success(response))

        let cardinalResponse = fakeObject(of: CardinalResponse.self)
        mockCardinalSession.didValidateHandler?(cardinalResponse)

        wait(for: [exp], timeout: 0.1)
    }

    func testStartCallSuccess() {
        let exp = expectation(description: "start completion should be called")
        service.start(cardBin: "123456", completion: { (result) in
            XCTAssertEqual(result.value, "fingerPrintId")
            XCTAssertNil(result.error)

            XCTAssertEqual(self.mockLogger.loggedMessages.count, 1)
            let loggedMessage = self.mockLogger.loggedMessages.first!
            XCTAssertEqual(loggedMessage.0, "DeviceFingerPrinting completed successfully")
            XCTAssertEqual(loggedMessage.1, .success)

            exp.fulfill()
        })

        let response = ThreeDSecureJWTResponse(deviceFingerprintingId: "fingerPrintId",
                                               jwt: "jwt")
        mockWebService.getJWTTokenCompletion?(.success(response))
        mockCardinalSession.didCompleteHandler?("")

        wait(for: [exp], timeout: 0.1)
    }

    func testContinueInvalidSdkChallengePayload() {
        let sdkChallengePayload = "InvalidSdkChallengePayload"
        service.challenge(sdkChallengePayload: sdkChallengePayload,
                          completion: { result in
                            let error = result.error as NSError?
                            XCTAssertEqual(error, Errors.invalidOptions("sdkChallengePayload"))
        })
    }

    func testContinueCardinalCalledForThreeDS2() {
        service.start(cardBin: "123456", completion: { (result) in
        })
        let response = ThreeDSecureJWTResponse(deviceFingerprintingId: "fingerPrintId",
                                               jwt: "jwt")
        mockWebService.getJWTTokenCompletion?(.success(response))

        let sdkChallengePayload = base64EncodedChallengePayload()
        service.challenge(sdkChallengePayload: sdkChallengePayload,
                          completion: { _ in
        })

        XCTAssertTrue(mockCardinalSession.didCallContinue)
    }

    func testContinueCardinalNotCalledForThreeDS1() {
        service.start(cardBin: "123456", completion: { (result) in
        })
        let response = ThreeDSecureJWTResponse(deviceFingerprintingId: "fingerPrintId",
                                               jwt: "jwt")
        mockWebService.getJWTTokenCompletion?(.success(response))

        let sdkChallengePayload = base64EncodedChallengePayload(threeDSecureVersion: "1.0")
        service.challenge(sdkChallengePayload: sdkChallengePayload,
                          completion: { _ in
        })

        XCTAssertFalse(mockCardinalSession.didCallContinue)
    }

    func testFinalizeCalledWithoutPayloadIfCardinalPassesEmptyStringForJWT() {
        service.start(cardBin: "123456", completion: { (result) in
        })
        let response = ThreeDSecureJWTResponse(deviceFingerprintingId: "fingerPrintId",
                                               jwt: "jwt")
        mockWebService.getJWTTokenCompletion?(.success(response))

        let sdkChallengePayload = base64EncodedChallengePayload()
        service.challenge(sdkChallengePayload: sdkChallengePayload,
                          completion: { _ in
        })

        service.cardinalSession(cardinalSession: nil,
                                stepUpValidated: nil,
                                serverJWT: nil)

        XCTAssertNotNil(mockWebService.didCallFinalizeWithPayload)
        XCTAssertNil(mockWebService.didCallFinalizeWithPayload!.payload)
    }

    func testContinueWhenFinalizeReturnsSuccess() {
        service.start(cardBin: "123456", completion: { (result) in
        })
        let response = ThreeDSecureJWTResponse(deviceFingerprintingId: "fingerPrintId",
                                               jwt: "jwt")
        mockWebService.getJWTTokenCompletion?(.success(response))

        let exp = expectation(description: "start completion should be called")

        let sdkChallengePayload = base64EncodedChallengePayload()
        service.challenge(sdkChallengePayload: sdkChallengePayload,
                          completion: { result in
                            XCTAssertNil(result.error)
                            XCTAssertEqual(result.value, "challengeId")
                            exp.fulfill()
        })

        service.cardinalSession(cardinalSession: nil,
                                stepUpValidated: nil,
                                serverJWT: nil)

        mockWebService.finalizeCompletion?(.success(Data()))

        wait(for: [exp], timeout: 0.1)
    }

    func testContinueWhenFinalizeReturnsFailiure() {
        service.start(cardBin: "123456", completion: { (result) in
        })
        let response = ThreeDSecureJWTResponse(deviceFingerprintingId: "fingerPrintId",
                                               jwt: "jwt")
        mockWebService.getJWTTokenCompletion?(.success(response))

        let exp = expectation(description: "start completion should be called")

        let sdkChallengePayload = base64EncodedChallengePayload()
        service.challenge(sdkChallengePayload: sdkChallengePayload,
                          completion: { result in
                            let error = result.error as NSError?
                            XCTAssertNotNil(error)
                            XCTAssertEqual(error?.code, 100)
                            exp.fulfill()
        })

        service.cardinalSession(cardinalSession: nil,
                                stepUpValidated: nil,
                                serverJWT: nil)

        let error = NSError(domain: "Test Error Domain", code: 100, userInfo: nil)
        mockWebService.finalizeCompletion?(.failure(error))

        wait(for: [exp], timeout: 0.1)
    }

    private func setupMerchantConfig() {
        merchantConfiguration = PaysafeSDK.MerchantConfiguration(username: "username",
                                                                 password: "password",
                                                                 accountId: "accountId")
    }

    private func base64EncodedChallengePayload(threeDSecureVersion: String = "2.0") -> String {
        let challenge = ChallengePayload(transactionId: "transactionId",
                                         acsUrl: "acsUrl",
                                         payload: "payload",
                                         accountId: "accountId",
                                         id: "challengeId",
                                         threeDSecureVersion: threeDSecureVersion)
        let sdkChallengePayload = try! JSONEncoder().encode(challenge).base64EncodedString()
        return sdkChallengePayload
    }

    class MockWebServiceHandler: ThreeDSecureWebServiceProtocol {
        var getJWTTokenCompletion: ((Result<ThreeDSecureJWTResponse, Error>) -> Void)?
        var finalizeCompletion: ((Result<Data, Error>) -> Void)?

        var didCallGetJWTTokenWithPayload: ThreeDSecureJWTRequestParameters?
        var didCallFinalizeWithPayload: ThreeDSecureFinalizeRequestParameters?

        func getJWTToken(with payload: ThreeDSecureJWTRequestParameters, correlationId: String, completion: @escaping (Result<ThreeDSecureJWTResponse, Error>) -> Void) {
            didCallGetJWTTokenWithPayload = payload
            getJWTTokenCompletion = completion
        }

        func finalize(accountID: String, threeDSecureAuthID: String, correlationId: String, with payload: ThreeDSecureFinalizeRequestParameters, completion: @escaping (Result<Data, Error>) -> Void) {
            finalizeCompletion = completion
            didCallFinalizeWithPayload = payload
        }

    }

    class MockCardinalSession: CardinalSessionProtocol {

        var didCompleteHandler: CardinalSessionSetupDidCompleteHandler?
        var didValidateHandler: CardinalSessionSetupDidValidateHandler?

        var didCallContinue: Bool = false

        func configure(_ sessionConfig: CardinalSessionConfiguration) {

        }

        func setup(jwtString: String,
                   completed didCompleteHandler: @escaping CardinalSessionSetupDidCompleteHandler,
                   validated didValidateHandler: @escaping CardinalSessionSetupDidValidateHandler) {
            self.didCompleteHandler = didCompleteHandler
            self.didValidateHandler = didValidateHandler
        }

        func continueWith(transactionId: String,
                          payload: String,
                          acsUrl: String,
                          directoryServerID: CCADirectoryServerID,
                          validationDelegate: CardinalValidationDelegate) {
            didCallContinue = true
        }
    }

    class MockLogger: LoggerProtocol {
        var loggedMessages: [(String, LoggerRequestParameters.EventType, String)] = []

        func log(message: String, eventType: LoggerRequestParameters.EventType, correlationId: String) {
            loggedMessages.append((message, eventType, correlationId))
        }
    }
}

extension Result {
    var error: Error? {
        switch self {
        case .success:
            return nil
        case let .failure(failure):
            return failure
        }
    }

    var value: Success? {
        switch self {
        case let .success(value):
            return value
        case .failure(_):
            return nil
        }
    }
}

func fakeObject<T>(of type: T.Type) -> T {
    let className = String(describing: type)
    let objectClass: AnyClass! = NSClassFromString(className)
    let objectType : NSObject.Type = objectClass as! NSObject.Type
    let object: NSObject = objectType.init() as NSObject
    let castedObject = object as! T
    return castedObject
}
