//
//  Utils.swift
//  Paysafe_SDK
//
//  Created by Tsvetelina Stoyanova on 19.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(utf8).base64EncodedString()
    }
}

extension Data {
    public func json() -> [String: Any]? {
        let json = try? JSONSerialization.jsonObject(with: self, options: .allowFragments)
        return json as? [String: Any]
    }
}

extension NSData {
    @objc public func json() -> [String: Any]? {
        return (self as Data).json()
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hexString  = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString as String)

        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let redComponent = Int(color >> 16) & mask
        let greenComponent = Int(color >> 8) & mask
        let blueComponent = Int(color) & mask

        let red   = CGFloat(redComponent) / 255.0
        let green = CGFloat(greenComponent) / 255.0
        let blue  = CGFloat(blueComponent) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0

        return String(format: "#%06x", rgb)
    }
}

extension UIApplication {
    var topmostController: UIViewController? {
        let keyWindow = windows.filter { $0.isKeyWindow }.first
        guard var topmostController = keyWindow?.rootViewController else {
            return nil
        }
        while let presentedViewController = topmostController.presentedViewController {
            topmostController = presentedViewController
        }
        return topmostController
    }
}
