//
//  CustomerVaultFakeToken.swift
//  Paysafe_SDK
//
//  Created by Veselin Cholakov on 1.09.20.
//  Copyright © 2020 Paysafe. All rights reserved.
//

import Foundation

@objc public class CustomerVaultFakeToken: NSObject, Encodable {
    private let cardNumber: String
    private let applicationExpirationDate: String
    private let transactionAmount: String
    private let cardholderName: String

    @objc public init(cardNumber: String, applicationExpirationDate: String, transactionAmount: String, cardholderName: String) {
        self.applicationExpirationDate = applicationExpirationDate
        self.cardNumber = cardNumber
        self.transactionAmount = transactionAmount
        self.cardholderName = cardholderName
    }
    
    enum CodingKeys: String, CodingKey {
        case cardNumber = "applicationPrimaryAccountNumber"
        case applicationExpirationDate
        case transactionAmount
        case cardholderName
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(cardNumber, forKey: .cardNumber)
        try container.encode(transactionAmount, forKey: .transactionAmount)
        try container.encode(applicationExpirationDate, forKey: .applicationExpirationDate)
        try container.encode(cardholderName, forKey: .cardholderName)
    }
    
}
