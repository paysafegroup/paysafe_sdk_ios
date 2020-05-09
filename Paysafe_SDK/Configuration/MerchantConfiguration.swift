//
//  MerchantConfiguration.swift
//  Paysafe_SDK
//
//  Created by Ivelin Davidov on 17.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

extension PaysafeSDK {
    @objc(PaysafeSDKMerchantConfiguration) public class MerchantConfiguration: NSObject {
        @objc public let apiKey: String
        @objc public let accountId: String

        @objc public init(username: String,
                          password: String,
                          accountId: String) {
            self.apiKey = "\(username):\(password)".toBase64()
            self.accountId = accountId
        }

        @objc public init(apiKey: String,
                          accountId: String) {
            self.apiKey = apiKey
            self.accountId = accountId
        }
    }

    @objc(PaysafeSDKApplePayMerchantConfiguration) public class ApplePayMerchantConfiguration: NSObject {
        @objc public let applePayMerchantId: String
        @objc public let countryCode: String
        @objc public let currencyCode: String

        @objc public init(applePayMerchantId: String,
                          countryCode: String,
                          currencyCode: String) {
            self.applePayMerchantId = applePayMerchantId
            self.countryCode = countryCode
            self.currencyCode = currencyCode
        }
    }
}
