# Paysafe SDK

    The Paysafe iOS SDK allows merchants to process payments from within their iOS mobile applications. 
    Both traditional card payment and Apple Pay payment methods are supported with this SDK. 
    Updated to support 3DS 2 functionality.
    
    To simplify the process of integration the iOS SDK, it was published and available as Cocoapod. 

# System requirements

* iOS 10.0+ / macOS 10.15+
* Xcode 11+
* Swift 5+

# Support

It Supports:
* 'Non Apple Pay' for iOS 10.0 and above
* 'Apple Pay' iOS 10.0 and above

# Installation

Installation is available via CocoaPods:

CocoaPods is a dependency manager for Cocoa projects. For usage and installation instructions, visit their [website](https://cocoapods.org). To integrate iOS Paysafe SDK into your Xcode project using CocoaPods, specify it in your Podfile:

`pod 'Paysafe_SDK', '<latest_published_version>'`

# Usage

After installing the Paysafe_SDK cocoapod, the only requirement to start using the SDK is simply by importing it into your project:

* Swift:
```
import Paysafe_SDK
```
        
* Objective-C:
```
@import Paysafe_SDK;
```

# Apple Pay

To start using Apple Pay in your application or site, you have to follow these steps:
* Login with your Paysafe back-office account and follow the procedure: [here](https://developer.paysafe.com/en/sdks/mobile/ios/integrating-with-the-ios-sdk/apple-pay-setup/initial-configuration-for-apple-pay/)
* Open Xcode. Enable Apple Pay on the Capabilities tap and choose your Merchant ID. Xcode setup with screenshot can be found on [this page](https://developer.paysafe.com/en/sdks/mobile/ios/integrating-with-the-ios-sdk/apple-pay-setup/xcode-setup/).

 **WARNING**: Testing Apple Pay on non-production environment requires adding Sandbox account in Apple Developer Portal.

# License

MIT License

Copyright (c) 2020 Paysafe Group
