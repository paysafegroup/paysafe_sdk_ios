//
//  CardinalJWTRequestParameters.swift
//  Paysafe_SDK
//
//  Created by Ivelin Davidov on 18.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

struct ThreeDSecureJWTRequestParameters: Encodable {
    let accountId: String
    let cardBin: String
    let sdkInfo: SDKInfo

    enum CardCodingKeys: String, CodingKey {
        case cardBin
    }

    enum CodingKeys: String, CodingKey {
        case sdk
        case accountId
        case card
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountId, forKey: .accountId)
        try container.encode(sdkInfo, forKey: .sdk)

        var cardContainer = container.nestedContainer(keyedBy: CardCodingKeys.self, forKey: .card)
        try cardContainer.encode(cardBin, forKey: .cardBin)
    }
}
