//
//  WebViewController.swift
//  Paysafe_SDK
//
//  Created by Tsvetelina Stoyanova on 16.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class WebViewController: UIViewController {
    private enum Constants {
        static let javaScriptError = "javaScriptError"
        static let javaScriptSuccess = "javaScriptSuccess"
        static let javaScriptCallbackHandlerName = "challengeCompleted"
    }

    var cancelCallback: (() -> Void)?
    private var payload: String?
    private var callBack: ((Result <Any?, Error>) -> Void)?
    private var spinner = UIActivityIndicatorView()

    private lazy var webView: WKWebView = {
        let userContentController = WKUserContentController()
        userContentController.add(self, name: Constants.javaScriptCallbackHandlerName)

        let webConfig = WKWebViewConfiguration()
        webConfig.userContentController = userContentController

        let webView = WKWebView(frame: UIScreen.main.bounds, configuration: webConfig)
        webView.navigationDelegate = self
        return webView
    }()

    private let merchantConfiguration: PaysafeSDK.MerchantConfiguration

    init(merchantConfiguration: PaysafeSDK.MerchantConfiguration) {
        self.merchantConfiguration = merchantConfiguration

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        guard let urlPath = PaysafeSDK.getEnvironmentURLPath() else {
            return
        }

        spinner.color = .lightGray
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()

        view = webView
        webView.scrollView.layer.masksToBounds = false

        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        webView.loadFileURL(urlPath, allowingReadAccessTo: urlPath.deletingLastPathComponent())

        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        if let customUI = PaysafeSDK.uiConfiguration?.toolbarConfiguration {
            customizeNavigationBar(configuration: customUI)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissController))
        }
    }

    private func customizeNavigationBar(configuration: ToolbarConfiguration) {
        if let backgroundColor = configuration.backgroundColor {
            navigationController?.navigationBar.barTintColor = UIColor(hexString: backgroundColor)
        }

        let rightBarButtonItem: UIBarButtonItem

        if let cancelButtonName = configuration.buttonText {
            rightBarButtonItem = UIBarButtonItem(title: cancelButtonName, style: .plain, target: self, action: #selector(dismissController))
        } else {
            rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissController))
        }
        navigationItem.rightBarButtonItem = rightBarButtonItem

        if let font = configuration.textFont {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.white
            ]

            navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
            navigationItem.rightBarButtonItem?.setTitleTextAttributes(titleTextAttributes, for: .normal)
            navigationItem.rightBarButtonItem?.setTitleTextAttributes(titleTextAttributes, for: .highlighted)
        }
    }

    func continueWith(payload: String?, callBack: ((Result <Any?, Error>) -> Void)?) {
        self.payload = payload
        self.callBack = callBack
    }

    @objc func dismissController() {
        cancelCallback?()
        UIApplication.shared.topmostController?.dismiss(animated: true, completion: nil)
    }

    private func getJavaScriptString() -> String? {
        guard let payload = payload else {
            return nil
        }

        let environment = PaysafeSDK.getEnvironmentNameForWebSDK()
        let apiKey = merchantConfiguration.apiKey

        return "paysafe.threedsecure.challenge(\"\(apiKey)\", { environment: \"\(environment)\", sdkChallengePayload: \"\(payload)\"}, function (id, error) {webkit.messageHandlers.\(Constants.javaScriptCallbackHandlerName).postMessage({\"\(Constants.javaScriptSuccess)\": id, \"\(Constants.javaScriptError)\": error});});"
    }

    private func handleSpinner(for request: URLRequest) {
        if let urlString = request.url?.absoluteString,
            (urlString.contains("pareq") || urlString.contains("EAFService/jsp/v1/profile")) {
            spinner.stopAnimating()
        }
    }
}

// MARK: - WKWebview delegte methods
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation?) {

        guard let javaScriptString = getJavaScriptString() else {
            callBack?(.failure(Errors.internalSDKError))
            return
        }

        webView.evaluateJavaScript(javaScriptString) { [weak self] _, error in
            if let error = error {
                self?.callBack?(.failure(error))
            }
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        handleSpinner(for: navigationAction.request)
        decisionHandler(.allow)
    }
}

extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == Constants.javaScriptCallbackHandlerName {
            guard let messageDictionary = message.body as? [String: Any] else {
                callBack?(.failure(Errors.internalSDKError))
                return
            }

            if let result = messageDictionary[Constants.javaScriptSuccess] {
                callBack?(.success(result))
            } else if let errorMessage = messageDictionary[Constants.javaScriptError] as? Error {
                callBack?(.failure(errorMessage))
            } else {
                assert(false)
                callBack?(.failure(Errors.internalSDKError))
            }
        }
    }
}
