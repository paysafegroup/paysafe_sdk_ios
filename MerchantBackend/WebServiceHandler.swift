//
//  WebServiceHandler.swift
//  Example
//
//  Created by Ivelin Davidov on 19.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation
import Paysafe_SDK

private let timeoutInterval: TimeInterval = 10

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum RequestError : Int, Error {
    case badRequest         = 400
    case notFound           = 404
    case methodNotAllowed   = 405
    case serverError        = 500
    case noConnection       = -1009
    case timeOutError       = -1001
}

class WebServiceHandler: NSObject {
    static let domain = "example.webServiceHandler"

    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: configuration)
        return urlSession
    }()

    private lazy var authorizedData: String? = {
        guard let merchantConfiguration = PaysafeSDK.merchantConfiguration else {
            return nil
        }

        let authorizationField = "Basic \(merchantConfiguration.apiKey)"
        return authorizationField
    }()

    func callWebService<RequestData: Encodable, Response: Decodable>(with urlString: String,
                                                                     requestData: RequestData?,
                                                                     method: HTTPMethod,
                                                                     completion: @escaping (Result<Response, Error>) -> Void) {
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
                           completion: { result in
                            let mappedResult: Result<Response, Error> = WebServiceHandler.mapResponse(dataResponse: result)
                            completion(mappedResult)
        })
    }

    private static func mapResponse<Response: Decodable>(dataResponse: Result<Data, Error>) -> Result<Response, Error> {
        let mappedResponse = dataResponse.flatMap({ (data) -> Result<Response, Error> in
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(Response.self, from: data)
                return .success(result)
            }
            catch let error {
                return .failure(error)
            }
        })
        return mappedResponse
    }

    private func callWebServiceWith(urlString: String,
                                    requestData: Data?,
                                    method: HTTPMethod,
                                    completion: @escaping (Result<Data, Error>) -> Void) {

        guard let requestURL = URL(string: urlString) else {
            let error = NSError(domain: WebServiceHandler.domain,
                                code: RequestError.badRequest.rawValue,
                                userInfo:[ NSLocalizedDescriptionKey: "Cannot create URL from string: \(urlString)"])
            completion(.failure(error))
            return
        }

        guard let authorizedData = authorizedData else {
            let error = NSError(domain: WebServiceHandler.domain,
                                code: RequestError.badRequest.rawValue,
                                userInfo:[ NSLocalizedDescriptionKey: "Missing parameters for merchantUserID or merchantPassword"])
            completion(.failure(error))
            return
        }

        var request = URLRequest(url: requestURL,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: timeoutInterval)

        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": authorizedData
        ]

        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = requestData

        let task = session.dataTask(with: request) { data, response, error in

            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    let genericError = NSError(domain: WebServiceHandler.domain,
                                               code: RequestError.notFound.rawValue,
                                               userInfo:[ NSLocalizedDescriptionKey: "Response not found"])
                    completion(.failure(genericError))
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) || httpResponse.statusCode == 304 else {
                    let httpError = NSError(domain: WebServiceHandler.domain,
                                            code: httpResponse.statusCode,
                                            userInfo:[ NSLocalizedDescriptionKey: "Request failed with error code: \(httpResponse.statusCode)"])
                    completion(.failure(httpError))
                    return
                }

                if let data = data {
                    completion(.success(data))
                }
            }
        }

        task.resume()
    }
}

extension String {
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
