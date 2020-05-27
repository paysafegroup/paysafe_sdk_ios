//
//  ApplePayHelperProtocols.swift
//  Paysafe_SDK
//
//  Created by Tsvetelina Stoyanova on 15.10.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation
import PassKit

public typealias PKPaymentAuthorizationExtensionProtocol = PKPaymentViewControllerProtocol & PKAuthorizationPresenterProtocol

public protocol PKPaymentViewControllerProtocol {
    static func canMakePayments() -> Bool
    static func canMakePayments(usingNetworks supportedNetworks: [PKPaymentNetwork]) -> Bool
}

public protocol PKAuthorizationPresenterProtocol {
    typealias PKAuthorizationPresenterCallback = (_ result: Result<PKPayment, Error>) -> Void

    static func present(request: PKPaymentRequest,
                        delegate: PKPaymentAuthorizationViewControllerDelegate) throws
}

extension PKPaymentAuthorizationViewController: PKPaymentAuthorizationExtensionProtocol {
    public static func present(request: PKPaymentRequest,
                               delegate: PKPaymentAuthorizationViewControllerDelegate) throws {

        guard let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request) else {
            throw Errors.internalSDKError
        }

        applePayController.delegate = delegate
        UIApplication.shared.topmostController?.present(applePayController, animated: true, completion: nil)
    }
}
