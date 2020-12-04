//
//  ChallengePayload.swift
//  Paysafe_SDK
//
//  Created by Tsvetelina Stoyanova on 15.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

struct ChallengePayload: Codable {
    let transactionId: String
    let payload: String
    let accountId: String
    let id: String
    let threeDSecureVersion: String

    static func challenge(from payloadString: String) -> ChallengePayload? {
        guard let payloadDecoded = payloadString.fromBase64(),
            let data = payloadDecoded.data(using: .utf8),
            let challengePayload = try? JSONDecoder().decode(ChallengePayload.self, from: data) else {
                return nil
        }

        return challengePayload
    }
}
