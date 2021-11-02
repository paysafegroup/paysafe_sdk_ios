//
//  CustomerVaultServiceTests.swift
//  Paysafe_SDKTests
//
//  Created by Ivelin Davidov on 15.10.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation
@testable import Paysafe_SDK
import XCTest

class CustomerVaultServiceTests: XCTestCase {

    func testCreateSingleUseTokenErrorIsPropagated() {
        let mockWebService = MockWebServiceHandler()
        let service = CustomerVaultService(webServiceHandler: mockWebService)

        let card = Card(cardNumber: "4000000000000001",
                        cardExpiry: Card.Expiry(month: "12", year: "2022"),
                        cvv: nil)
        let error = NSError(domain: "Test Error Domain", code: 100, userInfo: nil)

        let exp = expectation(description: "createSingleUseToken completion should be called")
        service.createSingleUseToken(card: card,
                                     completion: { result in
            let error = result.error as NSError?
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 100)
            exp.fulfill()
        })

        mockWebService.callWebServiceCompletionBlock(with: Result<SingleUseToken, Error>.failure(error))

        wait(for: [exp], timeout: 0.1)
    }

    func testCreateSingleUseTokenSuccessIsPropagated() {
        let mockWebService = MockWebServiceHandler()
        let service = CustomerVaultService(webServiceHandler: mockWebService)

        let card = Card(cardNumber: "4000000000000001",
                        cardExpiry: Card.Expiry(month: "12", year: "2022"),
                        cvv: nil)

        let token = mockedSingleUseToken()

        let exp = expectation(description: "createSingleUseToken completion should be called")
        service.createSingleUseToken(card: card,
                                     completion: { result in
                                        XCTAssertNotNil(result.value)
                                        XCTAssertEqual(result.value, token)
                                        exp.fulfill()
        })

        mockWebService.callWebServiceCompletionBlock(with: .success(token))

        wait(for: [exp], timeout: 0.1)
    }

    func testCreateSingleUseTokenErrorIsPropagatedInObjCAPI() {
        let mockWebService = MockWebServiceHandler()
        let service = CustomerVaultService(webServiceHandler: mockWebService)

        let card = Card(cardNumber: "4000000000000001",
                        cardExpiry: Card.Expiry(month: "12", year: "2022"),
                        cvv: nil)
        let error = NSError(domain: "Test Error Domain", code: 100, userInfo: nil)

        let exp = expectation(description: "createSingleUseToken completion should be called")
        service.createSingleUseToken(card: card,
                                     completion: { (resultToken, resultError) in
                                        let error = resultError as NSError?
                                        XCTAssertNotNil(error)
                                        XCTAssertEqual(error?.code, 100)
                                        XCTAssertNil(resultToken)
                                        exp.fulfill()
        })

        mockWebService.callWebServiceCompletionBlock(with: Result<SingleUseToken, Error>.failure(error))

        wait(for: [exp], timeout: 0.1)
    }

    func testCreateSingleUseTokenSuccessIsPropagatedInObjCAPI() {
        let mockWebService = MockWebServiceHandler()
        let service = CustomerVaultService(webServiceHandler: mockWebService)

        let card = Card(cardNumber: "4000000000000001",
                        cardExpiry: Card.Expiry(month: "12", year: "2022"),
                        cvv: nil)

        let token = mockedSingleUseToken()

        let exp = expectation(description: "createSingleUseToken completion should be called")
        service.createSingleUseToken(card: card,
                                     completion: { resultToken, resutError in
                                        XCTAssertNotNil(resultToken)
                                        XCTAssertEqual(resultToken, token)
                                        XCTAssertNil(resutError)
                                        exp.fulfill()
        })

        mockWebService.callWebServiceCompletionBlock(with: .success(token))

        wait(for: [exp], timeout: 0.1)
    }

    func testCreateApplePaySingleUseTokenErrorIsPropagated() {
        let mockWebService = MockWebServiceHandler()
        let service = CustomerVaultService(webServiceHandler: mockWebService)

        let mockTokenWrapper = mockApplePayTokenWrapper()
        let error = NSError(domain: "Test Error Domain", code: 100, userInfo: nil)

        let exp = expectation(description: "createApplePaySingleUseToken completion should be called")
        service.createApplePaySingleUseToken(mockTokenWrapper,
                                             completion: { result in
                                                let error = result.error as NSError?
                                                XCTAssertNotNil(error)
                                                XCTAssertEqual(error?.code, 100)
                                                exp.fulfill()
        })

        mockWebService.callWebServiceCompletionBlock(with: Result<ApplePaySingleUseToken, Error>.failure(error))

        wait(for: [exp], timeout: 0.1)
    }

    func testCreateApplePaySingleUseTokenSuccessIsPropagated() {
        let mockWebService = MockWebServiceHandler()
        let service = CustomerVaultService(webServiceHandler: mockWebService)

        let mockTokenWrapper = mockApplePayTokenWrapper()
        let mockSingleUseToken = mockApplePaySingleUseToken()

        let exp = expectation(description: "createApplePaySingleUseToken completion should be called")
        service.createApplePaySingleUseToken(mockTokenWrapper,
                                             completion: { result in

                                                XCTAssertNotNil(result.value)
                                                XCTAssertEqual(result.value, mockSingleUseToken)
                                                exp.fulfill()
        })

        mockWebService.callWebServiceCompletionBlock(with: .success(mockSingleUseToken))

        wait(for: [exp], timeout: 0.1)
    }

}

class MockWebServiceHandler: WebServiceHandlerProtocol {
    private var completionBlock: Any?

    var urlStringCalled: String!

    func callWebService<RequestData, Response>(with urlString: String,
                                               requestData: RequestData?,
                                               method: HTTPMethod,
                                               correlationId: String,
                                               completion: @escaping (Result<Response, Error>) -> Void)
        where RequestData: Encodable, Response: Decodable {
            urlStringCalled = urlString
            completionBlock = completion
    }

    func callWebServiceCompletionBlock<Response>(with result: Result<Response, Error>)
        where Response: Decodable {
            guard let completion = completionBlock as? (Result<Response, Error>) -> Void else {
                assert(false)
                return
            }

            completion(result)
    }

}

extension XCTest {
    func mockedSingleUseToken() -> SingleUseToken {
        let json = """
{
   "id":"71b4bab0-2083-4a09-8d42-b0a563876de8",
   "paymentToken":"SCdivObz7Wz66pLz",
   "timeToLiveSeconds":899,
   "billingAddress":{
      "street":"100 Queen Street West",
      "street2":"Unit 201",
      "city":"Toronto",
      "country":"CA",
      "state":"ON",
      "zip":"M5H 2N2"
   },
   "card":{
      "cardBin":"400000",
      "lastDigits":"1091",
      "cardExpiry":{
         "year":2022,
         "month":1
      },
      "holderName":"MR. JOHN SMITH",
      "cardType":"VI",
      "cardCategory":"CREDIT"
   }
}
"""
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let token = try! decoder.decode(SingleUseToken.self, from: jsonData)
        return token
    }

    func mockApplePayTokenWrapper() -> ApplePayTokenWrapper {
        let json = """
{
  "version":"EC_v1",
  "data":"<passkit_encrypted_payment_data>",
  "signature":"<signature_for_payment_and_header_data>",
  "header":{
     "transactionId":"b53e22ef6669ce7f50951cfd6821908f4e679f050f5a551a1b5f6202253136ae",
     "ephemeralPublicKey":"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEB39YqvWZG0NOYjbkL5D61Mxip6uw23Q7m8gWgxL41k4fs0BgJ+MFcIGYOH86kAGL/wjiftDahRkUnzOGls2hzw==",
     "publicKeyHash":"O5gJ/P5sQ7ufMZQXA7ccLoOkJ13VNknbu+4K0TaCQXE="
  }
}
"""
        let jsonData = json.data(using: .utf8)!

        let wrapper = ApplePayTokenWrapper.create(from: jsonData)!
        return wrapper

    }

    func mockApplePaySingleUseToken() -> ApplePaySingleUseToken {
        let json = """
{
   "id":"123456789",
   "paymentToken":"ABC4AFQQBC5UR5H",
   "timeToLiveSeconds":899,
   "applePayPaymentToken":{
      "version":"EC_v1",
      "signature":"<signature_for_payment_and_header_data>",
      "header":{
         "transactionId":"b53e22ef6669ce7f50951cfd6821908f4e679f050f5a551a1b5f6202253136ae",
         "publicKeyHash":"O5gJ/P5sQ7ufMZQXA7ccLoOkJ13VNknbu+4K0TaCQXE="
      }
   },
   "card":{
      "lastDigits":"1111",
      "holderName":"Joe Smith"
   },
   "transaction":{
      "amount":1000,
      "currencyCode":"USD"
   }
}
"""
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let token = try! decoder.decode(ApplePaySingleUseToken.self, from: jsonData)
        return token
    }
}
