//
//  WebViewControllerTests.swift
//  Paysafe_SDKTests
//
//  Created by Tsvetelina Stoyanova on 17.10.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import XCTest
@testable import Paysafe_SDK
import WebKit

private enum Constants {
    static let errorCode = 9999
    static let username = "username"
    static let password = "password"
    static let accountId = "accountId"
    static let domainName = "testDomain"
    static let errorDescription = "Javascript error occurred."
    static let payload = "sdkChallengePayload"
    static let dummyPayload = "dummy"
    static let authenticationID = "authenticationID"
    static let javaScriptError = "javaScriptError"
    static let javaScriptSuccess = "javaScriptSuccess"
    static let javaScriptCallbackHandlerName = "challengeCompleted"
}

class WebViewControllerTests: XCTestCase {
    var merchantConfiguration: PaysafeSDK.MerchantConfiguration!
    var webController: WebViewController!

    override func setUp() {
        super.setUp()
        merchantConfiguration = PaysafeSDK.MerchantConfiguration(username: Constants.username,
                                                                 password: Constants.password,
                                                                 accountId: Constants.accountId)
        webController = WebViewController(merchantConfiguration: merchantConfiguration)
        let _ = webController.view
    }

    override func tearDown() {
        super.tearDown()
        merchantConfiguration = nil
        webController = nil
    }

    func testCallWebServiceWithoutPayloadReturnsError() {
        let exp = expectation(description: "continueWith completion should be called with 'internalSDKError' error")

        webController.continueWith(payload: nil) { result in
            let error = result.error! as NSError
            XCTAssertNotNil(error)
            XCTAssertEqual(error, Errors.internalSDKError)
            exp.fulfill()
        }

        let wkWebview = webController.view as! WKWebView
        webController.webView(wkWebview, didFinish: nil)

        wait(for: [exp], timeout: 0.1)
    }

    func testWebviewSetupCorrectly() {
        XCTAssertTrue(webController.view.classForCoder === WKWebView.self)
    }

    func testDidEvaluateInvalidJavaScript() {
        let exp = expectation(description: "continueWith completion should be called JavaScript exeption error")

        webController.continueWith(payload: Constants.dummyPayload) { result in
            switch result {
            case .failure(_):
                exp.fulfill()

            default:
                return
           }
        }

        let wkWebview = webController.view as! WKWebView
        webController.webView(wkWebview, didFinish: nil)

        wait(for: [exp], timeout: 5.0)
    }

    func testWebviewMessagingFailure() {
        let exp = expectation(description: "continueWith completion should be called with Javascript error")

        let thrownError = NSError(domain: Constants.domainName,
                                  code: Constants.errorCode,
                                  userInfo: [NSLocalizedDescriptionKey: Constants.errorDescription])

        webController.continueWith(payload: Constants.payload) { result in
            let nsError = result.error! as NSError
            XCTAssertNotNil(nsError)
            XCTAssertEqual(nsError, thrownError)
            exp.fulfill()
        }

        let message = MockWKScriptMessage(mockName: Constants.javaScriptCallbackHandlerName,
                                          mockBody: [Constants.javaScriptError: thrownError])
        webController.userContentController(WKUserContentController(), didReceive: message)

        wait(for: [exp], timeout: 0.1)
    }

    func testWebviewMessagingSuccess() {
        let exp = expectation(description: "continueWith completion should be called and receive message")

        webController.continueWith(payload: Constants.payload) { result in
            XCTAssertNil(result.error)

            if case let .success(message) = result {
                let receivedAuthenticationID = message as? String
                XCTAssertNotNil(receivedAuthenticationID)
                XCTAssertEqual(receivedAuthenticationID, Constants.authenticationID)
            }

            exp.fulfill()
        }

        let message = MockWKScriptMessage(mockName: Constants.javaScriptCallbackHandlerName,
                                          mockBody: [Constants.javaScriptSuccess: Constants.authenticationID])
        webController.userContentController(WKUserContentController(), didReceive: message)

        wait(for: [exp], timeout: 0.1)
    }

    func testWebviewMessageBodyNotADictionary() {
        let exp = expectation(description: "continueWith completion should be called - message not provided")

        webController.continueWith(payload: Constants.payload) { result in
            let error = result.error! as NSError
            XCTAssertNotNil(error)
            XCTAssertEqual(error, Errors.internalSDKError)
            exp.fulfill()
        }

        let message = MockWKScriptMessage(mockName: Constants.javaScriptCallbackHandlerName,
                                          mockBody: "")
        webController.userContentController(WKUserContentController(), didReceive: message)

        wait(for: [exp], timeout: 0.1)
    }

    class MockWKScriptMessage: WKScriptMessage {
        let mockName: String
        let mockBody: Any

        override var name: String {
            return mockName
        }

        override var body: Any {
            return mockBody
        }

        init(mockName: String, mockBody: Any) {
            self.mockName = mockName
            self.mockBody = mockBody
            super.init()
        }
    }
}
