//
//  Environment.swift
//  Paysafe_SDK
//
//  Created by Ivelin Davidov on 16.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

extension PaysafeSDK {
    // NOTE: This is declared as public as it needs to be used in Obj-C within the PaysafeSDK framework.
    // More about this can be read here - https://developer.apple.com/documentation/swift/imported_c_and_objective-c_apis/importing_swift_into_objective-c
    // Once we remove the Obj-C code using this we can revert this to internal.
    @objc public static func getBaseUrlPath() -> String {
        return currentEnvironment.getBaseUrlPath()
    }

    static func getEnvironmentNameForWebSDK() -> String {
        return currentEnvironment.getEnvironmentNameForWebSDK()
    }

    static func getEnvironmentURLPath() -> URL? {
        return currentEnvironment.getEnvironmentURLPath()
    }

    @objc(PaysafeSDKEnvironment) public enum Environment: Int, CaseIterable {
        case test
        case production

        fileprivate func getBaseUrlPath() -> String {
            switch currentEnvironment {
            case .test:
                return "https://api.test.paysafe.com"
            case .production:
                return "https://api.paysafe.com"
            }
        }

        fileprivate func getEnvironmentNameForWebSDK() -> String {
            switch currentEnvironment {
            case .test:
                return "TEST"
            case .production:
                return "LIVE"
            }
        }

        fileprivate func getEnvironmentURLPath() -> URL? {
            let bundle = Bundle(for: PaysafeSDK.self)

            switch currentEnvironment {
            case .test:
                return bundle.url(forResource: "paysafe_sdk_test_index", withExtension: "html")
            case .production:
                return bundle.url(forResource: "paysafe_sdk_index", withExtension: "html")
            }
        }
    }
}
