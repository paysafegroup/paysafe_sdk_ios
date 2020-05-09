//
//  Merchandise.swift
//  Paysafe_SDK
//
//  Created by Tsvetelina Stoyanova on 14.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import UIKit

@objcMembers public class ShippingMethod: NSObject {
    let price: NSDecimalNumber
    let title: String
    let shippingDescription: String

    public init(price: NSDecimalNumber, title: String, description: String) {
        self.price = price
        self.title = title
        self.shippingDescription = description
    }
}

public enum ShippingType {
    case electronic
    case delivered(method: ShippingMethod)

    public init(method: ShippingMethod?) {
        guard let method = method else {
            self = .electronic
            return
        }

        self = .delivered(method: method)
    }
}

@objcMembers public class CartDetails: NSObject {
    let cartId: String
    let payTo: String
    let shippingOptions: [ShippingMethod]

    public init(cartId: String, payTo: String, shippingOptions: [ShippingMethod]) {
        self.cartId = cartId
        self.payTo = payTo
        self.shippingOptions = shippingOptions
    }
}

@objcMembers public class Merchandise: NSObject {
    let image: UIImage?
    let title: String
    let price: NSDecimalNumber
    let amount: NSInteger
    let productDescription: String
    var shippingType: ShippingType

    public required init(image: UIImage?,
                         title: String,
                         price: NSDecimalNumber,
                         amount: NSInteger,
                         shippingMethod: ShippingMethod?,
                         description: String) {
        self.image = image
        self.title = title
        self.price = price
        self.amount = amount
        self.shippingType = ShippingType(method: shippingMethod)
        self.productDescription = description
    }

    func priceForAmount() -> NSDecimalNumber {
        let calculetedPrice = price.multiplying(by: NSDecimalNumber(value: amount))
        return calculetedPrice
    }

    func total() -> NSDecimalNumber {
        let calculetedPrice = priceForAmount()

        switch shippingType {
        case .delivered(let method):
            return calculetedPrice.adding(method.price)
        case .electronic:
            return calculetedPrice
        }
    }
}
