//
//  ApplePayServiceProtocol.swift
//  Paysafe_SDK
//
//  Created by Tsvetelina Stoyanova on 13.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation
import PassKit

@objc public protocol ApplePayServiceProtocol: class {

    /**
     - Parameters:
        - payment: Result of the query - a PKPayment instance, or `nil` if an error occurred.
        - error: An error that indicates why the query failed, or `nil` if it was succesful.
     */
    typealias PaymentCallback = (_ payment: PKPayment?, _ error: Error?) -> Void

    func isApplePaySupported() -> Bool

    func beginPayment(_ product: Merchandise, cartDetails: CartDetails, completion: @escaping PaymentCallback)
}
