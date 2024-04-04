//
//  ApplePayService.swift
//  Paysafe_SDK
//
//  Created by Tsvetelina Stoyanova on 13.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation
import PassKit

@objcMembers public class ApplePayService: NSObject {

    private let supportedPaymentNetworks: [PKPaymentNetwork] = [.amex, .masterCard, .visa]
    private let webHandler: WebServiceHandler
    private var applePaymentDidSucceed = false

    private let applePayMerchantConfiguration: PaysafeSDK.ApplePayMerchantConfiguration?
    private var paymentCompleted: ((Result< PKPayment, Error>) -> Void)?
    private let paymentViewControllerType: PKPaymentAuthorizationExtensionProtocol.Type

    private var merchandise: Merchandise?
    private var cartDetails: CartDetails?
    private var payment: PKPayment?

    public convenience override init() {
        self.init(merchantConfiguration: nil,
                  applePayMerchantConfiguration: nil)
    }

    public convenience init(merchantConfiguration: PaysafeSDK.MerchantConfiguration? = nil,
                            applePayMerchantConfiguration: PaysafeSDK.ApplePayMerchantConfiguration? = nil) {

        self.init(merchantConfiguration: merchantConfiguration,
                  applePayMerchantConfiguration: applePayMerchantConfiguration,
                  paymentViewControllerType: PKPaymentAuthorizationViewController.self)
    }

    init(merchantConfiguration: PaysafeSDK.MerchantConfiguration? = nil,
         applePayMerchantConfiguration: PaysafeSDK.ApplePayMerchantConfiguration? = nil,
         paymentViewControllerType: PKPaymentAuthorizationExtensionProtocol.Type) {

        let merchantConfiguration = merchantConfiguration ?? PaysafeSDK.merchantConfiguration
        webHandler = WebServiceHandler(merchantConfiguration: merchantConfiguration)

        self.applePayMerchantConfiguration = applePayMerchantConfiguration ?? PaysafeSDK.applePayMerchantConfiguration
        self.paymentViewControllerType = paymentViewControllerType
    }

    /* If we are running the app in Device & we have valid/apple verified Amex, MasterCard and
     Visa cards available in Device passbook ( for apple pay ) then this method retuns TRUE.
     If we are running the simulator it returns FALSE.
     */
    private func haveValidNetworks() -> Bool {
        return paymentViewControllerType.canMakePayments(usingNetworks: supportedPaymentNetworks)
    }

    private func calculateSummaryItemsFrom(merchandise: Merchandise?, cartDetails: CartDetails?) -> [PKPaymentSummaryItem] {
        var summaryItems = [PKPaymentSummaryItem]()

        guard let merchandise = merchandise,
            let cartDetails = cartDetails else {
            return summaryItems
        }

        summaryItems.append(PKPaymentSummaryItem(label: merchandise.title, amount: merchandise.price))
        summaryItems.append(PKPaymentSummaryItem(label: "Amount price", amount: merchandise.priceForAmount()))

        switch merchandise.shippingType {
        case .delivered(let method):
            summaryItems.append(PKPaymentSummaryItem(label: "Shipping", amount: method.price))
        case .electronic:
            break
        }

        summaryItems.append(PKPaymentSummaryItem(label: cartDetails.payTo, amount: merchandise.total()))

        return summaryItems
    }

    private func updatedSummaryItemsForSelected(shippingMethod: PKShippingMethod) -> [PKPaymentSummaryItem]? {
        let selectedShippingMethods = cartDetails?.shippingOptions.filter { $0.title == shippingMethod.identifier }

        guard let selectedShippingMethod = selectedShippingMethods?.first else {
            return nil
        }
        merchandise?.shippingType = ShippingType.delivered(method: selectedShippingMethod)
        let calculatedItems = calculateSummaryItemsFrom(merchandise: merchandise, cartDetails: cartDetails)
        return calculatedItems
    }
}

extension ApplePayService: ApplePayServiceProtocol {
    /**
     Returns whether device can make payments with Apple Pay.

     User may not be able to make payments for a variety of reasons. For example, this functionality may not be supported by their hardware,
     it may be restricted by parental controls or user doesn't have valid/verified card payment networks ( i.e `Amex, Visa & MasterCard` ) in Passbook.

     - Returns: `true` if device is not restricted by parental controls,
     supports Apple Pay and user is using one of the authorized (verified) card payment networks; otherwise `false`.
     */
    public func isApplePaySupported() -> Bool {
       return paymentViewControllerType.canMakePayments() && haveValidNetworks()
    }

    /**
     *BeginPayment* function starts Apple Pay flow with provided details

     - Parameters:
        - product: Information for selected product, configured with:
            * `image`
            * `title`
            * `price` - price per item
            * `amount` - quantity
            * `description` - additional product details
            * `shippingMethod` - information about selected shipping option

        - cartDetails: Cart object with values:
            * `cartId` - cart object id
            * `payTo` - merchant name
            * `shippingOptions` - array of available shipping options

        - completion: Invoked when request failed or completed.
            * It returns **PKPayment** instance if operation passes successfully or an error otherwise.
            PKPayment represents the result of a payment request. `Successful` payments have a **PKPaymentToken** which contains a payment credential
            encrypted to the merchant identifier specified in the request, and when requested, the user's shipping address and chosen shipping method.
     */
    public func beginPayment(_ product: Merchandise, cartDetails: CartDetails, completion: @escaping PaymentCallback) {
        beginPayment(product, cartDetails: cartDetails) { result in
            switch result {
            case let .failure(error):
                completion(nil, error)
            case let .success(paymentInfo):
                completion(paymentInfo, nil)
            }
        }
    }

    /**
     - Parameter result: `Result<PKPayment, Error>` object where
        * `PKPayment` represents successful result of the query, or `nil` if an error occurred.
        * `Error` represents an error that indicates why the query failed, or `nil` if query was succesful.
     */
    public typealias PaymentResultCallback = (_ result: Result<PKPayment, Error>) -> Void

    /**
     *BeginPayment* function starts Apple Pay flow with provided details

     - Parameters:
        - product: Information for selected product, configured with:
            * `image`
            * `title`
            * `price` - price per item
            * `amount` - quantity
            * `description` - additional product details
            * `shippingMethod` - information about selected shipping option

        - cartDetails: Cart object with values:
            * `cartId` - cart object id
            * `payTo` - merchant name
            * `shippingOptions` - array of available shipping options

        - completion: Invoked when request failed or completed.
            * It returns Result<PKPayment, Error> object with **PKPayment** instance if operation passes successfully or an error otherwise.
            PKPayment represents the result of a payment request. `Successful` payments have a **PKPaymentToken** which contains a payment credential
            encrypted to the merchant identifier specified in the request, and when requested, the user's shipping address and chosen shipping method.
     */
    public func beginPayment(_ product: Merchandise, cartDetails: CartDetails, completion: @escaping PaymentResultCallback) {
        guard let applePayMerchantConfiguration = self.applePayMerchantConfiguration else {
            completion(.failure(Errors.invalidMerchantConfigurationError))
            return
        }

        let merchantIdentifier = applePayMerchantConfiguration.applePayMerchantId

        merchandise = product
        self.cartDetails = cartDetails
        paymentCompleted = completion
        applePaymentDidSucceed = false

        let request = PKPaymentRequest()
        
        request.merchantIdentifier = merchantIdentifier
        request.supportedNetworks = supportedPaymentNetworks
        request.merchantCapabilities = .capability3DS
        request.countryCode = applePayMerchantConfiguration.countryCode
        request.currencyCode = applePayMerchantConfiguration.currencyCode

        request.paymentSummaryItems = calculateSummaryItemsFrom(merchandise: product, cartDetails: cartDetails)
        request.requiredShippingContactFields = [.emailAddress, .name, .phoneNumber, .phoneticName, .postalAddress]

        switch product.shippingType {
        case .delivered:
            request.requiredShippingContactFields = [.postalAddress]

            var shippingMethods = [PKShippingMethod]()

            for shippingMethod in cartDetails.shippingOptions {
                let method = PKShippingMethod(label: shippingMethod.title, amount: shippingMethod.price)
                method.identifier = shippingMethod.title
                method.detail = shippingMethod.shippingDescription
                shippingMethods.append(method)
            }

            request.shippingMethods = shippingMethods

        case .electronic:
            request.requiredShippingContactFields = [.emailAddress]
         }

        do {
            try paymentViewControllerType.present(request: request,
                                                  delegate: self)
        } catch let error {
            completion(.failure(error))
        }
    }
}

extension ApplePayService: PKPaymentAuthorizationViewControllerDelegate {
    @available(iOS 11.0, *)
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                                   didAuthorizePayment payment: PKPayment,
                                                   handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        self.payment = payment
        applePaymentDidSucceed = true
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }

    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                                   didAuthorizePayment payment: PKPayment,
                                                   completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        applePaymentDidSucceed = true
        self.payment = payment
        completion(.success)
    }

    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)

        guard let payment = self.payment,
            applePaymentDidSucceed else {
                paymentCompleted?(.failure(Errors.transactionFailedOrCanceled))
                return
        }

        paymentCompleted?(.success(payment))
    }

    @available(iOS 11.0, *)
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                                   didSelect shippingMethod: PKShippingMethod,
                                                   handler completion: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void) {
        guard let updatedItems = updatedSummaryItemsForSelected(shippingMethod: shippingMethod) else {
            completion(PKPaymentRequestShippingMethodUpdate(paymentSummaryItems: []))
            return
        }

        completion(PKPaymentRequestShippingMethodUpdate(paymentSummaryItems: updatedItems))
    }

    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                                   didSelect shippingMethod: PKShippingMethod,
                                                   completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        guard let updatedItems = updatedSummaryItemsForSelected(shippingMethod: shippingMethod) else {
            completion(.failure, [])
            return
        }

        completion(.success, updatedItems)
    }
}
