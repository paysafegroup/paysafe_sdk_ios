//
//  TokenizedCard.swift
//  Paysafe_SDK
//
//  Created by Ivelin Davidov on 16.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

@objcMembers public class TokenizedCard: NSObject, Decodable {
    @objc public class CardExpiry: NSObject, Decodable {
        let month: Int
        let year: Int
    }

    public let cardBin: String?
    public let lastDigits: String
    public let holderName: String?
    public let cardExpiry: CardExpiry?
}
