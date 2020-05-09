//
//  BillingAddress.swift
//  Paysafe_SDK
//
//  Created by Tsvetelina Stoyanova on 11.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

@objc public class BillingAddress: NSObject, Codable {
    let street: String?
    let street2: String?
    let city: String?
    let country: String
    let state: String?
    let zip: String

    @objc public init(street: String?,
                      street2: String?,
                      city: String?,
                      country: String,
                      state: String?,
                      zip: String) {
        self.street = street
        self.street2 = street2
        self.city = city
        self.country = country
        self.state = state
        self.zip = zip
    }
}
