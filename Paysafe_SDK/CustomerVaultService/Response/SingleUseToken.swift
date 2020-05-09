//
//  SingleUseToken.swift
//  Paysafe_SDK
//
//  Created by Ivelin Davidov on 14.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

@objcMembers public class SingleUseToken: NSObject, Decodable {
    public let id: String
    public let paymentToken: String
    public let timeToLiveSeconds: Int
    public let card: TokenizedCard?
    public let billignAddress: BillingAddress?
}
