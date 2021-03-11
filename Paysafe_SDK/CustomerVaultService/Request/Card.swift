//
//  Card.swift
//  Paysafe_SDK
//
//  Created by Ivelin Davidov on 16.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

@objc public class Card: NSObject, Encodable {
    @objc public class Expiry: NSObject, Encodable {
        private let month: String
        private let year: String

        @objc public init(month: String, year: String) {
            self.month = month
            self.year = year
        }
    }

    private let cardNumber: String
    private let cardExpiry: Expiry
    private let cvv: String?
    private let holderName: String?
    private let billingAddress: BillingAddress?

    @objc public init(cardNumber: String,
                      cardExpiry: Expiry,
                      cvv: String?,
                      holderName: String? = nil,
                      billingAddress: BillingAddress? = nil) {
        self.cardNumber = cardNumber
        self.cardExpiry = cardExpiry
        self.cvv = cvv
        self.holderName = holderName
        self.billingAddress = billingAddress
    }

    enum CodingKeys: String, CodingKey {
        case cardNumber = "cardNum"
        case cardExpiry
        case cvv
        case holderName
        case billingAddress
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(cardNumber, forKey: .cardNumber)
        try container.encode(cardExpiry, forKey: .cardExpiry)
        try container.encodeIfPresent(cvv, forKey: .cvv)
        try container.encodeIfPresent(holderName, forKey: .holderName)
        try container.encodeIfPresent(billingAddress, forKey: .billingAddress)
    }
}
