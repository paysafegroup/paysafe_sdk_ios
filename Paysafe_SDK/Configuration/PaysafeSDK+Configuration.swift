//
//  PaysafeSDK+Configuration.swift
//  Paysafe_SDK
//
//  Created by Ivelin Davidov on 17.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

/**
    PaysafeSDK object required to be set before using the SDK.

    - Class properties:
        - **currentEnvironment**: defines which environment to be used. `currentEnvironment` can be:
            * production
            * test

            By default provided one is `production`.

        - **merchantConfiguration**: Parameter which provides the SDK required information about the merchant. This object contains:
            * username - registered Paysafe API Key username
            * password - registered Paysafe API Key password
            * accountId - registered Paysafe Account Number
            * countryCode
            * currencyCode
            * applePayMerchantId - optional parameter. Required to be set when Apple Pay is available option.
                                   This is the same id set in Project -> Capabilities section.

         - **timeoutInterval**: Interval in seconds before request timeout. By default is 10 seconds.

         - **uiConfiguration**: `optional parameter`. Set when custom UI configuration of the 3DS need to be applied.

            Available options are:
            * labelConfiguration - sets all labels and heading labels styles
            * textBoxConfiguration - apply textBox styling
            * toolbarConfiguration - provide toolbar customization options
            * cancelButtonConfiguration
            * resendButtonConfiguration
            * continueButtonConfiguration
            * verifyButtonConfiguration

            Button configurations can be set all at once using:
            ```
            @objc public func setupAllButtons(withConfiguration buttonConfiguration: ButtonConfiguration)
            ```
            method. It affects all buttons.

            If you want to provide different styles for each or some of the buttons use:

            ```
            @objc public func set(buttonConfiguration: ButtonConfiguration, type: ButtonConfiguration.ButtonConfigurationType)
            ```
            `buttonConfiguration`: desired style for applying

            `type`: One of the following:

                * continues
                * cancel
                * resend
                * verify

 */
@objcMembers public class PaysafeSDK: NSObject {
    /**
     Current SDK environment.

     Default value is `.production`. For development use `.test`.
    */
    static public var currentEnvironment: Environment = .production

    /**
     Provide registered Paysafe API credentials
    */
    static public var merchantConfiguration: MerchantConfiguration?

    /**
     Provide registered configuration for
     */
    static public var applePayMerchantConfiguration: ApplePayMerchantConfiguration?

    /**
     Styles 3DS 2.0 input form
     */
    static public var uiConfiguration: UIConfiguration?

    /**
     Timeout interval.

     10 seconds by default.
     */
    static public var timeoutInterval: TimeInterval = 10.0

    static let sdkInfo = SDKInfo(type: "IOS", version: getSDKVersion())
}

private extension PaysafeSDK {
    enum Constants {
        static let sdkPlistName = "paysafe_sdk_versioning-Info"
        static let sdkVersionKey = "PaysafeSDKBundleVersion"
        static let sdkDefaultVersionValue = "1.0.0"
    }

    static func getSDKVersion() -> String {
        guard let path = Bundle(for: ThreeDSecureService.self).path(forResource: Constants.sdkPlistName, ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let preferences = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil),
            let plistDict = preferences as? [String: AnyObject],
            let sdkVersion = plistDict[Constants.sdkVersionKey] as? String else {
                assert(false, "SDK version should be present")
                return Constants.sdkDefaultVersionValue
        }
        return sdkVersion
    }
}
