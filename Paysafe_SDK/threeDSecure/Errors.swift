//
//  Errors.swift
//  Paysafe_SDK
//
//  Created by Ivelin Davidov on 2.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

enum Errors {
    private static let paysafeSDKErrorDomain = "com.paysafe.sdk"

    enum ErrorType {
        static let noConnection = "No connection to server."
        static let invalidResponse = "Error communicating with server."
        static let invalidApiKey = "The supplied apiKey parameter is not a string or is not a valid BASE64 encoded value."
        static let internalSDKError = "Unhandled error occurred."
        static let invalidOptions = "Invalid option fields: "
        static let invalidMerchantConfiguration = "Invalid merchant configuration setup."
        static let transactionFailedOrCanceled = "Transaction failed or canceled."
    }

    static var noResponseFromServerError: NSError {
        return NSError(domain: paysafeSDKErrorDomain,
                       code: 9001,
                       userInfo: [NSLocalizedDescriptionKey: ErrorType.noConnection])
    }

    static var invalidResponseError: NSError {
        return NSError(domain: paysafeSDKErrorDomain,
                       code: 9002,
                       userInfo: [NSLocalizedDescriptionKey: ErrorType.invalidResponse])
    }

    static var invalidApiKeyError: NSError {
        return NSError(domain: paysafeSDKErrorDomain,
                       code: 9013,
                       userInfo: [NSLocalizedDescriptionKey: ErrorType.invalidApiKey])
    }

    static var internalSDKError: NSError {
        return NSError(domain: paysafeSDKErrorDomain,
                       code: 9014,
                       userInfo: [NSLocalizedDescriptionKey: ErrorType.internalSDKError])
    }

    static func invalidOptions(_ options: String...) -> NSError {
        let optionsText = options.joined(separator: " ")
        return NSError(domain: paysafeSDKErrorDomain,
                       code: 9015,
                       userInfo: [NSLocalizedDescriptionKey: ErrorType.invalidOptions + optionsText])
    }

    static var invalidMerchantConfigurationError: NSError {
        return NSError(domain: paysafeSDKErrorDomain,
                       code: 9501,
                       userInfo: [NSLocalizedDescriptionKey: ErrorType.invalidMerchantConfiguration])
    }

    static var transactionFailedOrCanceled: NSError {
        return NSError(domain: paysafeSDKErrorDomain,
                       code: 9601,
                       userInfo: [NSLocalizedDescriptionKey: ErrorType.transactionFailedOrCanceled])
    }
}
