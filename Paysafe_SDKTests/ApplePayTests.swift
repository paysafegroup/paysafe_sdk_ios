//
//  ApplePayTests.swift
//  Paysafe_SDKTests
//
//  Created by Tsvetelina Stoyanova on 14.10.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation
@testable import Paysafe_SDK
import XCTest

class ApplePayTests: XCTestCase {
    var product: Merchandise!
    var cartData: CartDetails!
    var shippingMethodOptions: [ShippingMethod]!

    var applePayService: ApplePayService!
    var applePayMerchantConfiguration: PaysafeSDK.ApplePayMerchantConfiguration!
    var paymentViewControllerType: MockPKPaymentAuthorizationExtensionProtocol.Type!

    override func setUp() {
        super.setUp()
        setupApplePayMerchantConfig()
        paymentViewControllerType = MockPKPaymentAuthorizationExtensionProtocol.self
        applePayService = ApplePayService(applePayMerchantConfiguration: applePayMerchantConfiguration,
                                          paymentViewControllerType: paymentViewControllerType)

        mockPaymentDetails()
    }

    override func tearDown() {
        super.tearDown()
        product = nil
        cartData = nil
        shippingMethodOptions = nil
        applePayService = nil
        applePayMerchantConfiguration = nil
        paymentViewControllerType = nil
    }

    func testBeginPaymentWithInvalidApplePayConfiguration() {
        let applePayService = ApplePayService()
        PaysafeSDK.applePayMerchantConfiguration = nil

        let exp = expectation(description: "beginPayment completion should be called with error")
        applePayService.beginPayment(product, cartDetails: cartData) { _, error in
                                        let error = error as NSError?
                                        XCTAssertEqual(error, Errors.invalidMerchantConfigurationError)
                                        exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testCanMakeApplePayPayments() {
        MockPKPaymentAuthorizationExtensionProtocol.canMakePaymentsResult = true
        MockPKPaymentAuthorizationExtensionProtocol.canMakePaymentsUsingNetworksResult = true

        let paymentViewControllerType = MockPKPaymentAuthorizationExtensionProtocol.self
        let applePayService = ApplePayService(paymentViewControllerType: paymentViewControllerType)

        let isApplePaySupported = applePayService.isApplePaySupported()
        XCTAssertTrue(isApplePaySupported, "isApplePaySupported should return true")
    }

    func testIsPKPaymentAuthorizationViewControllerPresented() {
        let paymentViewControllerType = MockPKPaymentAuthorizationExtensionProtocol.self
        let applePayService = ApplePayService(applePayMerchantConfiguration: applePayMerchantConfiguration,
                                              paymentViewControllerType: paymentViewControllerType)

        applePayService.beginPayment(product, cartDetails: cartData, completion: {_, _ in})
        XCTAssertNotNil(paymentViewControllerType.didPresentDelegate)
        XCTAssertNotNil(paymentViewControllerType.paymentController)
    }

    func testPresenterRequestCorrectPriceRecalculation() {
        let singleItemPrice = NSDecimalNumber(value: 20.5)
        let singleItem = Merchandise(image: nil,
                                     title: "Llama California Shipping",
                                     price: singleItemPrice,
                                     amount: 1,
                                     shippingMethod: shippingMethodOptions.last,
                                     description: "3-5 Business Days")

        let calculatedPrice = shippingMethodOptions.last?.price.adding(singleItemPrice)

        let paymentViewControllerType = MockPKPaymentAuthorizationExtensionProtocol.self
        let applePayService = ApplePayService(applePayMerchantConfiguration: applePayMerchantConfiguration,
                                              paymentViewControllerType: paymentViewControllerType)

        applePayService.beginPayment(singleItem, cartDetails: cartData, completion: {_, _ in})
        XCTAssertEqual(paymentViewControllerType.didPresentRequest.paymentSummaryItems.last?.amount, calculatedPrice)
    }

    func testPresenterRequestShippingTypeElectronic() {
        let digitalGood = Merchandise(image: nil,
                                      title: "Online Services",
                                      price: NSDecimalNumber(value: 20),
                                      amount: 3,
                                      shippingMethod: nil,
                                      description: "")

        let paymentViewControllerType = MockPKPaymentAuthorizationExtensionProtocol.self
        let applePayService = ApplePayService(applePayMerchantConfiguration: applePayMerchantConfiguration,
                                              paymentViewControllerType: paymentViewControllerType)

        applePayService.beginPayment(digitalGood, cartDetails: cartData, completion: {_, _ in})
        XCTAssertNil(paymentViewControllerType.didPresentRequest.shippingMethods)
    }

    func testPresenterRequestAllItemsSetForDeliverable() {
        let paymentViewControllerType = MockPKPaymentAuthorizationExtensionProtocol.self
        let applePayService = ApplePayService(applePayMerchantConfiguration: applePayMerchantConfiguration,
                                              paymentViewControllerType: paymentViewControllerType)

        applePayService.beginPayment(product, cartDetails: cartData, completion: {_, _ in})
        XCTAssertEqual(paymentViewControllerType.didPresentRequest.merchantIdentifier, applePayMerchantConfiguration.applePayMerchantId)
        XCTAssertEqual(paymentViewControllerType.didPresentRequest.countryCode, applePayMerchantConfiguration.countryCode)
        XCTAssertEqual(paymentViewControllerType.didPresentRequest.currencyCode, applePayMerchantConfiguration.currencyCode)
        XCTAssertEqual(paymentViewControllerType.didPresentRequest.shippingMethods?.count, cartData.shippingOptions.count)
        XCTAssertEqual(paymentViewControllerType.didPresentRequest.supportedNetworks, [.amex, .masterCard, .visa])
        XCTAssertEqual(paymentViewControllerType.didPresentRequest.merchantCapabilities, .capability3DS)
    }

    func testPresenterRequestMerchantCapability3DS() {
        let request = PKPaymentRequest()
        request.merchantIdentifier = applePayMerchantConfiguration.applePayMerchantId
        request.countryCode = applePayMerchantConfiguration.countryCode
        request.currencyCode = applePayMerchantConfiguration.currencyCode
        request.supportedNetworks = [.amex, .masterCard, .visa]
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: cartData.payTo, amount: NSDecimalNumber(value: 50))]
        request.merchantCapabilities = .capability3DS

        let paymentViewControllerType = MockPKPaymentAuthorizationExtensionProtocol.self
        let applePayService = ApplePayService(applePayMerchantConfiguration: applePayMerchantConfiguration,
                                              paymentViewControllerType: paymentViewControllerType)

        try? MockPKPaymentAuthorizationExtensionProtocol.present(request: request,
                                                                 delegate: applePayService)

        XCTAssertEqual(paymentViewControllerType.didPresentRequest.merchantCapabilities, .capability3DS)
    }

    func testApplePayCancelled() {
        let exp = expectation(description: "beginPayment completion should be called")

        applePayService.beginPayment(product, cartDetails: cartData, completion: { payment, error in
            let error = error as NSError?
            XCTAssertEqual(error, Errors.transactionFailedOrCanceled)
            exp.fulfill()
        })

        applePayService.paymentAuthorizationViewControllerDidFinish(paymentViewControllerType.paymentController!)
        wait(for: [exp], timeout: 0.1)
    }

    func testApplePayCompleted() {
        let paymentResult = PKPayment()
        let exp = expectation(description: "beginPayment should complete successfully with payment data")

        applePayService.beginPayment(product, cartDetails: cartData, completion: { payment, error in
            XCTAssertNotNil(payment)
            exp.fulfill()
        })

        if #available(iOS 11.0, *) {
            paymentViewControllerType.didPresentDelegate?.paymentAuthorizationViewController?(paymentViewControllerType.paymentController!,
                                                                                              didAuthorizePayment: paymentResult,
                                                                                              handler: { _ in })
        } else {
            paymentViewControllerType.didPresentDelegate?.paymentAuthorizationViewController?(paymentViewControllerType.paymentController!,
                                                                                              didAuthorizePayment: paymentResult,
                                                                                              completion: { _ in })
        }

        applePayService.paymentAuthorizationViewControllerDidFinish(paymentViewControllerType.paymentController!)
        wait(for: [exp], timeout: 0.1)
    }

    func testShippingMethodChangedAndSumRecalculated() {
        let singleItemPrice = NSDecimalNumber(value: 20.5)
        let singleItem = Merchandise(image: nil,
                                     title: "Llama California Shipping",
                                     price: singleItemPrice,
                                     amount: 1,
                                     shippingMethod: shippingMethodOptions.first,
                                     description: "3-5 Business Days")

        let reCalculatedPrice = shippingMethodOptions.last?.price.adding(singleItemPrice)

        applePayService.beginPayment(singleItem, cartDetails: cartData, completion: {_, _ in})

        let lastShippingMethod = paymentViewControllerType.didPresentRequest.shippingMethods!.last
        let presentationDelegate = paymentViewControllerType.didPresentDelegate

        if #available(iOS 11.0, *) {
            presentationDelegate?.paymentAuthorizationViewController?(paymentViewControllerType.paymentController!,
                                                                      didSelect: lastShippingMethod!,
                                                                      handler: { [weak self] updatedPaymentRequest in
                                                                        self?.paymentViewControllerType.didPresentRequest.paymentSummaryItems = updatedPaymentRequest.paymentSummaryItems
            })
        } else {
            presentationDelegate?.paymentAuthorizationViewController?(paymentViewControllerType.paymentController!,
                                                                      didSelect: lastShippingMethod!,
                                                                      completion: { [weak self] _, updatedItems in
                                                                        self?.paymentViewControllerType.didPresentRequest.paymentSummaryItems = updatedItems
            })
        }

        XCTAssertEqual(paymentViewControllerType.didPresentRequest.paymentSummaryItems.last?.amount, reCalculatedPrice)
    }

    func testShippingMethodNotFound() {
        applePayService.beginPayment(product, cartDetails: cartData, completion: {_, _ in})

        let updatedShippingMethod = PKShippingMethod(label: "Missing shipping option", amount: NSDecimalNumber(integerLiteral: 0))
        updatedShippingMethod.identifier = "identifier"
        updatedShippingMethod.detail = "detail"

        let presentationDelegate = paymentViewControllerType.didPresentDelegate

        if #available(iOS 11.0, *) {
            presentationDelegate?.paymentAuthorizationViewController?(paymentViewControllerType.paymentController!,
                                                                      didSelect: updatedShippingMethod,
                                                                      handler: { [weak self] updatedPaymentRequest in
                                                                        self?.paymentViewControllerType.didPresentRequest.paymentSummaryItems = updatedPaymentRequest.paymentSummaryItems
            })
        } else {
            presentationDelegate?.paymentAuthorizationViewController?(paymentViewControllerType.paymentController!,
                                                                      didSelect: updatedShippingMethod,
                                                                      completion: { [weak self] _, updatedItems in
                                                                        self?.paymentViewControllerType.didPresentRequest.paymentSummaryItems = updatedItems
            })
        }

        XCTAssertEqual(paymentViewControllerType.didPresentRequest.paymentSummaryItems.count, 0)
    }

    func testAuthorizationControllerInitiated() {
        let applePayService = ApplePayService()
        var nsError: NSError? = nil

        do {
            try PKPaymentAuthorizationViewController.present(request: PKPaymentRequest(), delegate: applePayService)
        } catch let error {
            nsError = error as NSError?
        }

        XCTAssertEqual(nsError, Errors.internalSDKError)
    }

    private func setupApplePayMerchantConfig() {
        applePayMerchantConfiguration = PaysafeSDK.ApplePayMerchantConfiguration(applePayMerchantId: "merchant.com.paysafe.documentation",
                                                                                 countryCode: "US",
                                                                                 currencyCode: "USD")
    }

    private func mockPaymentDetails() {
        shippingMethodOptions = [
            ShippingMethod(price: NSDecimalNumber(string: "5.00"), title: "Carrier Pigeon", description: "You'll get it someday."),
            ShippingMethod(price: NSDecimalNumber(string: "100.00"), title: "Racecar", description: "Vrrrroom! Get it by tomorrow!"),
            ShippingMethod(price: NSDecimalNumber(string: "900.00"), title: "Rocket Ship", description: "Look out your window!"),
        ]

        product = Merchandise(image: nil,
                              title: "Llama California Shipping",
                              price: NSDecimalNumber(value: 20),
                              amount: 3,
                              shippingMethod: shippingMethodOptions.first,
                              description: "3-5 Business Days")

        cartData = CartDetails(cartId: "123423",
                               payTo: "Llama Services, Inc.",
                               shippingOptions: shippingMethodOptions)
    }


    class MockPKPaymentAuthorizationExtensionProtocol: PKPaymentAuthorizationExtensionProtocol {
        static var canMakePaymentsResult = false
        static var canMakePaymentsUsingNetworksResult = false

        static var didPresentRequest: PKPaymentRequest!
        static var paymentController: PKPaymentAuthorizationViewController?
        static var didPresentDelegate: PKPaymentAuthorizationViewControllerDelegate?

        static func canMakePayments() -> Bool {
            return canMakePaymentsResult
        }

        static func canMakePayments(usingNetworks supportedNetworks: [PKPaymentNetwork]) -> Bool {
            return canMakePaymentsUsingNetworksResult
        }

        static func present(request: PKPaymentRequest,
                            delegate: PKPaymentAuthorizationViewControllerDelegate) throws {
            didPresentRequest = request
            didPresentDelegate = delegate
            paymentController =  PKPaymentAuthorizationViewController(paymentRequest: request)
        }
    }
}
