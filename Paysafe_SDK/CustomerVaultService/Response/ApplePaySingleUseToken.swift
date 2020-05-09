//
//  ApplePaySingleUseToken.swift
//  Paysafe_SDK
//
//  Created by Tsvetelina Stoyanova on 15.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

@objcMembers public class ApplePaySingleUseToken: NSObject, Decodable {
    @objc(ApplePaySingleUseTokenTransaction) public class Transaction: NSObject, Decodable {
        public let amount: Int
        public let currencyCode: String
    }

    public let id: String
    public let paymentToken: String
    public let timeToLiveSeconds: Int
    public let applePayPaymentToken: ApplePayToken
    public let card: TokenizedCard
    public let transaction: Transaction
}
