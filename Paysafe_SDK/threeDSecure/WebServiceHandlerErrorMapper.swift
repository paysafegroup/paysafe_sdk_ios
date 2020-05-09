//
//  WebServiceHandlerErrorMapper.swift
//  Paysafe_SDK
//
//  Created by Ivelin Davidov on 6.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

protocol WebServiceHandlerErrorMapperProtocol {
    func getError(httpResponse: HTTPURLResponse, data: Data?) -> Error
}

class WebServiceHandlerErrorMapper: WebServiceHandlerErrorMapperProtocol {
    func getError(httpResponse: HTTPURLResponse, data: Data?) -> Error {
        let error: Error
        if let mappedError = getInternalErrorIfAvailable(from: data),
            mappedError.code == ServerError.merchantConfigurationNotSet.rawValue {
            error = Errors.invalidMerchantConfigurationError
        } else if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
            error = Errors.invalidApiKeyError
        } else {
            error = Errors.internalSDKError
        }

        return error
    }

    private func getInternalErrorIfAvailable(from data: Data?) -> InternalError? {
        guard let data = data else {
            return nil
        }
        let jsonDecoder = JSONDecoder()
        let errorContainer = try? jsonDecoder.decode(InternalErrorContainer.self, from: data)
        return errorContainer?.error
    }

    private struct InternalErrorContainer: Decodable {
        let error: InternalError
    }

    private struct InternalError: Decodable {
        let code: String
        let message: String?
        let details: [String]?
    }

    private enum ServerError: String {
        case merchantConfigurationNotSet = "5050"
    }
}
