//
//  Logger.swift
//  Paysafe_SDK
//
//  Created by Tsvetelina Stoyanova on 7.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

struct LoggerRequestParameters: Encodable {
    let eventType: EventType
    let eventMessage: String
    let sdk: SDKInfo

    enum EventType: String, Encodable {
        case success = "SUCCESS"
        case internalSDKError = "INTERNAL_SDK_ERROR"
        case validationError = "VALIDATION_ERROR"
    }
}

/// Defines an interface for logging messages.
protocol LoggerProtocol {
    /**
        Logs a message.

        - Parameters:
            - message: The message to be logged.
            - eventType: The type of event that occurred. For available event types, see `LoggerRequestParameters.EventType`
            - correlationId: Unique identifier used to track related logs.
     */
    func log(message: String, eventType: LoggerRequestParameters.EventType, correlationId: String)
}

/// Logger that sends messages to remote server.
struct Logger: LoggerProtocol {
    private let baseUrl: String
    private let webHandler: WebServiceHandler

    init(logUrl: String,
         merchantConfiguration: PaysafeSDK.MerchantConfiguration?) {
        baseUrl = logUrl
        webHandler = WebServiceHandler(merchantConfiguration: merchantConfiguration)
    }

    func log(message: String, eventType: LoggerRequestParameters.EventType, correlationId: String) {
        let sdkInfo = PaysafeSDK.sdkInfo
        let requestInfo = LoggerRequestParameters(eventType: eventType, eventMessage: message, sdk: sdkInfo)

        webHandler.callWebService(with: baseUrl,
                                  requestData: requestInfo,
                                  method: .post,
                                  correlationId: correlationId,
                                  completion: { _ in
                                    // NOTE: We can't do much if the logging request fails
        })
    }
}
