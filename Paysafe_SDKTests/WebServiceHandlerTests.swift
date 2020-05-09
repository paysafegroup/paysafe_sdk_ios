//
//  WebServiceHandlerTests.swift
//  Paysafe_SDKTests
//
//  Created by Ivelin Davidov on 15.10.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation
@testable import Paysafe_SDK
import XCTest

class WebServiceHandlerTests: XCTestCase {
    var errorMapper: MockErrorMapper!
    var mockSession: MockURLSession!
    var merchantConfiguration: PaysafeSDK.MerchantConfiguration!

    override func setUp() {
        super.setUp()

        errorMapper = MockErrorMapper()
        mockSession = MockURLSession()
        merchantConfiguration = PaysafeSDK.MerchantConfiguration(username: "username",
                                                                 password: "password",
                                                                 accountId: "accountId")
    }

    func testCallWebServiceWithoutMerchantConfigurationReturnsError() {
        let handler = WebServiceHandler(errorMapper: errorMapper,
                                        merchantConfiguration: nil,
                                        session: mockSession)

        let exp = expectation(description: "completion should be called")
        let requestData = MockedRequest(name: "Ivan")

        handler.callWebService(with: "http://google.com",
                               requestData: requestData,
                               method: .post,
                               correlationId: "12345",
                               completion: { result in
                                let error = result.error as NSError?
                                XCTAssertEqual(error, Errors.invalidMerchantConfigurationError)
                                exp.fulfill()
        })

        wait(for: [exp], timeout: 0.1)
    }

    func testCallWebServiceEncodesRequestData() {
        let handler = WebServiceHandler(errorMapper: errorMapper,
                                        merchantConfiguration: merchantConfiguration,
                                        session: mockSession)

        let exp = expectation(description: "completion should be called")
        let requestData = MockedRequest(name: "Ivan")
        let jsonEncodedData = requestData.jsonEncodedData()

        handler.callWebService(with: "http://google.com",
                               requestData: requestData,
                               method: .post,
                               correlationId: "12345",
                               completion: { result in
                                exp.fulfill()
        })

        XCTAssertEqual(mockSession.request.httpBody, jsonEncodedData)
        mockSession.completionHandler(nil, nil, nil)

        wait(for: [exp], timeout: 0.1)
    }

    func testCallWebServiceWithDecodableResultEncodesRequestData() {
        let handler = WebServiceHandler(errorMapper: errorMapper,
                                        merchantConfiguration: merchantConfiguration,
                                        session: mockSession)

        let exp = expectation(description: "completion should be called")
        let requestData = MockedRequest(name: "Ivan")
        let jsonEncodedData = requestData.jsonEncodedData()

        handler.callWebService(with: "http://google.com",
                               requestData: requestData,
                               method: .post,
                               correlationId: "12345",
                               completion: { (result: Result<MockedResponse, Error>) in
                                exp.fulfill()
        })

        XCTAssertEqual(mockSession.request.httpBody, jsonEncodedData)
        mockSession.completionHandler(nil, nil, nil)

        wait(for: [exp], timeout: 0.1)
    }

    func testCallWebServiceWithDecodableResult() {
        let handler = WebServiceHandler(errorMapper: errorMapper,
                                        merchantConfiguration: merchantConfiguration,
                                        session: mockSession)

        let exp = expectation(description: "completion should be called")
        let requestData = MockedRequest(name: "Ivan")

        handler.callWebService(with: "http://google.com",
                               requestData: requestData,
                               method: .post,
                               correlationId: "12345",
                               completion: { (result: Result<MockedResponse, Error>) in
                                XCTAssertEqual(result.value?.name, "Test")
                                exp.fulfill()
        })

        let response = getURLResponse(statusCode: 200)
        let data = MockedResponse(name: "Test").jsonEncodedData()
        mockSession.completionHandler(data, response, nil)

        wait(for: [exp], timeout: 0.1)
    }

    func testCallWebServiceWithInvalidDecodableResult() {
        let handler = WebServiceHandler(errorMapper: errorMapper,
                                        merchantConfiguration: merchantConfiguration,
                                        session: mockSession)

        let exp = expectation(description: "completion should be called")
        let requestData = MockedRequest(name: "Ivan")

        handler.callWebService(with: "http://google.com",
                               requestData: requestData,
                               method: .post,
                               correlationId: "12345",
                               completion: { (result: Result<MockedResponse, Error>) in
                                let error = result.error as? DecodingError
                                XCTAssertNotNil(error)
                                exp.fulfill()
        })

        let response = getURLResponse(statusCode: 200)
        let data = Data()
        mockSession.completionHandler(data, response, nil)

        wait(for: [exp], timeout: 0.1)
    }

    func testCallWebServiceWithDataResult() {
        let handler = WebServiceHandler(errorMapper: errorMapper,
                                        merchantConfiguration: merchantConfiguration,
                                        session: mockSession)

        let exp = expectation(description: "completion should be called")
        let requestData = MockedRequest(name: "Ivan")

        let responseData = MockedResponse(name: "Test").jsonEncodedData()

        handler.callWebService(with: "http://google.com",
                               requestData: requestData,
                               method: .post,
                               correlationId: "12345",
                               completion: { result in
                                XCTAssertEqual(result.value, responseData)
                                exp.fulfill()
        })

        let response = getURLResponse(statusCode: 200)
        mockSession.completionHandler(responseData, response, nil)

        wait(for: [exp], timeout: 0.1)
    }

    func testURLSessionErrorIsHandled() {
        let handler = WebServiceHandler(errorMapper: errorMapper,
                                        merchantConfiguration: merchantConfiguration,
                                        session: mockSession)

        let exp = expectation(description: "completion should be called")
        let requestData = MockedRequest(name: "Ivan")

        handler.callWebService(with: "http://google.com",
                               requestData: requestData,
                               method: .post,
                               correlationId: "12345",
                               completion: { (result: Result<MockedResponse, Error>) in
                                let error = result.error as NSError?
                                XCTAssertNotNil(error)
                                // NOTE: WebServiceHandler is not directly returning errors it recieves. That's why here the error is not the one the URLSession returns via its completion.
                                XCTAssertEqual(error, Errors.noResponseFromServerError)
                                exp.fulfill()
        })

        let error = NSError(domain: "Test Error Domain", code: 100, userInfo: nil)
        mockSession.completionHandler(nil, nil, error)

        wait(for: [exp], timeout: 0.1)
    }

    func testMappedErrorForInvalidStatusCodes() {
        let handler = WebServiceHandler(errorMapper: errorMapper,
                                        merchantConfiguration: merchantConfiguration,
                                        session: mockSession)

        let exp = expectation(description: "completion should be called")
        let requestData = MockedRequest(name: "Ivan")

        handler.callWebService(with: "http://google.com",
                               requestData: requestData,
                               method: .post,
                               correlationId: "12345",
                               completion: { (result: Result<MockedResponse, Error>) in
                                let error = result.error as NSError?
                                XCTAssertNotNil(error)
                                XCTAssertEqual(error?.code, 101)
                                exp.fulfill()
        })

        let response = getURLResponse(statusCode: 400)
        errorMapper.returnedError = NSError(domain: "Mapped Error Domain", code: 101, userInfo: nil)
        mockSession.completionHandler(nil, response, nil)

        wait(for: [exp], timeout: 0.1)
    }

    func testRequestHeaders() {
        let handler = WebServiceHandler(errorMapper: errorMapper,
                                        merchantConfiguration: merchantConfiguration,
                                        session: mockSession)

        let requestData = MockedRequest(name: "Ivan")

        handler.callWebService(with: "http://google.com",
                               requestData: requestData,
                               method: .post,
                               correlationId: "12345",
                               completion: { (result: Result<MockedResponse, Error>) in
        })

        let headers = mockSession.request.allHTTPHeaderFields!

        XCTAssertEqual(headers["Accept"], "application/json")
        XCTAssertEqual(headers["Content-Type"], "application/json")
        XCTAssertEqual(headers["Authorization"], "Basic dXNlcm5hbWU6cGFzc3dvcmQ=")
        XCTAssertEqual(headers["X-INTERNAL-CORRELATION-ID"], "12345")
    }

    struct MockedRequest: Encodable {
        let name: String
    }

    struct MockedResponse: Codable, Equatable {
        let name: String
    }

    class MockURLSession: URLSessionProtocol {
        var completionHandler: ((Data?, URLResponse?, Error?) -> Void)!
        var request: URLRequest!

        func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
            self.request = request
            self.completionHandler = completionHandler

            let task = MockURLSessionDataTask()
            return task
        }

        class MockURLSessionDataTask: URLSessionDataTaskProtocol {
            func resume() {
            }
        }
    }

    class MockErrorMapper: WebServiceHandlerErrorMapperProtocol {
        var returnedError: Error!

        func getError(httpResponse: HTTPURLResponse, data: Data?) -> Error {
            return returnedError
        }
    }
}

extension Encodable {
    func jsonEncodedData() -> Data {
        let data = try! JSONEncoder().encode(self)
        return data
    }
}

extension XCTestCase {
    func getURLResponse(url: URL = URL(string: "www.google.com")!,
                        statusCode: Int,
                        httpVersion: String = "1.0",
                        headerFields: [String: String]? = nil) -> HTTPURLResponse {
        let response = HTTPURLResponse(url: url,
                                       statusCode: statusCode,
                                       httpVersion: httpVersion,
                                       headerFields: headerFields)!
        return response
    }
}
