//
//  WebServiceHandler.swift
//  Paysafe_SDK
//
//  Created by Tsvetelina Stoyanova on 12.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol WebServiceHandlerProtocol {
    func callWebService<RequestData, Response>(with urlString: String,
                                               requestData: RequestData?,
                                               method: HTTPMethod,
                                               correlationId: String,
                                               completion: @escaping (Result<Response, Error>) -> Void)
        where RequestData: Encodable, Response: Decodable
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: request,
                        completionHandler: completionHandler) as URLSessionDataTask
    }
}

class WebServiceHandler: NSObject, WebServiceHandlerProtocol {
    public static let domain = "com.paysafe.sdk.webServiceHandler"

    private let session: URLSessionProtocol

    private static func instantiateNewSession() -> URLSessionProtocol {
        let configuration = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: configuration)
        return urlSession
    }

    private lazy var authorizedData: String? = {
        guard let merchantConfiguration = merchantConfiguration else {
            return nil
        }

        let authorizationField = "Basic \(merchantConfiguration.apiKey)"
        return authorizationField
    }()

    private let errorMapper: WebServiceHandlerErrorMapperProtocol
    private let merchantConfiguration: PaysafeSDK.MerchantConfiguration?

    init(errorMapper: WebServiceHandlerErrorMapperProtocol = WebServiceHandlerErrorMapper(),
         merchantConfiguration: PaysafeSDK.MerchantConfiguration?,
         session: URLSessionProtocol = instantiateNewSession()) {
        self.errorMapper = errorMapper
        self.merchantConfiguration = merchantConfiguration
        self.session = session
    }

    func callWebService<RequestData: Encodable>(with urlString: String,
                                                requestData: RequestData?,
                                                method: HTTPMethod,
                                                correlationId: String,
                                                completion: @escaping (Result<Data, Error>) -> Void) {
        let data: Data?
        if let requestData = requestData {
            let encoder = JSONEncoder()
            data = try? encoder.encode(requestData)
        } else {
            data = nil
        }

        callWebServiceWith(urlString: urlString,
                           requestData: data,
                           method: method,
                           correlationId: correlationId,
                           completion: completion)
    }

    func callWebService<RequestData: Encodable, Response: Decodable>(with urlString: String,
                                                                     requestData: RequestData?,
                                                                     method: HTTPMethod,
                                                                     correlationId: String,
                                                                     completion: @escaping (Result<Response, Error>) -> Void) {
        callWebService(with: urlString,
                       requestData: requestData,
                       method: method,
                       correlationId: correlationId,
                       completion: { result in
                        let mappedResult: Result<Response, Error> = WebServiceHandler.mapResponse(dataResponse: result)
                        completion(mappedResult)
        })
    }

    private static func mapResponse<Response: Decodable>(dataResponse: Result<Data, Error>) -> Result<Response, Error> {
        let mappedResponse = dataResponse.flatMap({ data -> Result<Response, Error> in
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(Response.self, from: data)
                return .success(result)
            } catch let error {
                return .failure(error)
            }
        })
        return mappedResponse
    }

    private func callWebServiceWith(urlString: String,
                                    requestData: Data?,
                                    method: HTTPMethod,
                                    correlationId: String,
                                    completion: @escaping (Result<Data, Error>) -> Void) {
        guard let requestURL = URL(string: urlString) else {
            completion(.failure(Errors.internalSDKError))
            return
        }

        guard let authorizedData = authorizedData else {
            completion(.failure(Errors.invalidMerchantConfigurationError))
            return
        }

        var request = URLRequest(url: requestURL,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: PaysafeSDK.timeoutInterval)

        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": authorizedData,
            "X-INTERNAL-CORRELATION-ID": correlationId
        ]

        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = requestData

        let task = session.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.handleDataTaskCompletion(with: data,
                                               response: response,
                                               error: error,
                                               completion: completion)
            }
        }

        task.resume()
    }

    private func handleDataTaskCompletion(with data: Data?,
                                          response: URLResponse?,
                                          error: Error?,
                                          completion: @escaping (Result<Data, Error>) -> Void) {
            guard error == nil else {
                completion(.failure(Errors.noResponseFromServerError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(Errors.invalidResponseError))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) || httpResponse.statusCode == 304 else {
                let error = errorMapper.getError(httpResponse: httpResponse,
                                                 data: data)
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(Errors.internalSDKError))
                return
            }

            completion(.success(data))
    }
}
