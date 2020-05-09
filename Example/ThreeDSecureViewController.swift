//
//  ThreeDSecureViewController.swift
//  Example
//
//  Created by Ivelin Davidov on 18.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation
import UIKit
import Paysafe_SDK

class ThreeDSecureViewController: UIViewController {
    @IBOutlet var submitButton: UIButton!
    @IBOutlet private var amountTextField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private var merchantBackend: MerchantSampleBackend!
    private var cardBin: String!

    private lazy var threeDSecureService = {
       return ThreeDSecureService()
    }()

    private var isLoading: Bool = false {
        didSet {
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
            activityIndicator.isHidden = !isLoading
            submitButton.isEnabled = !isLoading
        }
    }

    func configure(cardBin: String, with merchantBackend: MerchantSampleBackend) {
        self.cardBin = cardBin
        self.merchantBackend = merchantBackend
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        amountTextField.text = "20"
        isLoading = false
    }

    @IBAction func startThreeDSecurePayment(_ sender: Any) {
        isLoading = true
        threeDSecureService.start(cardBin: cardBin,
                                  completion: { [weak self] result in
                                    self?.isLoading = false
                                    self?.didRecieveResultFromThreeDSecure(result)
        })
    }

    private func didRecieveResultFromThreeDSecure(_ result: Result<String, Error>) {
        guard let amount = Int(amountTextField.text ?? "") else {
            displayAlert(title: "Invalid amount", message: "You've entered an invalid amount")
            return
        }

        switch result {
        case let .failure(error):
            displayError(error)
        case let .success(deviceFingerPrintId):
            merchantBackend.getChallengePayload(for: amount,
                                                with: deviceFingerPrintId,
                                                completion: { [weak self] result in
                                                    self?.isLoading = false
                                                    self?.didGetChallengePayloadResult(result)
            })
        }
    }

    private func didGetChallengePayloadResult(_ result: Result<AuthenticationResponse, Error>) {
        switch result {
        case let .failure(error):
            displayError(error)
        case let .success(challengePayload):
            if let sdkChallengePayload = challengePayload.sdkChallengePayload {
                threeDSecureService.challenge(sdkChallengePayload: sdkChallengePayload,
                                              completion: { [weak self] (result: Result<String, Error>) in
                                                self?.onChallengeCompleted(result)
                })
            } else {
                displayAlert(title: "Success!", message: "No challenge, successfully completed transaction!")
            }
        }
    }

    private func didGetAuthenticationResult(_ result: Result<AuthenticationIdResponse, Error>) {
        switch result {
        case let .failure(error):
            displayError(error)
        case let .success(idResponse):
            displayAlert(title: nil, message: "Transaction completed with status: \(idResponse.status.stringValue())")
        }
    }

    private func onChallengeCompleted(_ result: Result<String, Error>) {
        switch result {
        case let .failure(error):
            isLoading = false
            displayError(error)
        case let .success(authenticationId):
            debugPrint("Here Auth ID is \(authenticationId)")

            merchantBackend.authenticate(authenticationId) { [weak self] result in
                self?.isLoading = false
                self?.didGetAuthenticationResult(result)
            }
        }
    }
}

extension ThreeDSecureViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
