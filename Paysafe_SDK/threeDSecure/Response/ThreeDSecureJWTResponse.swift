//
//  CardinalJWTResponse.swift
//  Paysafe_SDK
//
//  Created by Ivelin Davidov on 18.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

struct ThreeDSecureJWTResponse: Decodable {
    let deviceFingerprintingId: String
    let jwt: String
}
