//
//  ViewController.swift
//  Example
//
//  Created by Ivelin Davidov on 10.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import UIKit
import Paysafe_SDK

class AddCardViewController: UIViewController {

    private let cards: [(number: String, name: String)] = [
        ("4000000000001091", "3DS 2"),
        ("4000000000001000", "3DS 2 Frictionless"),
        ("4111111111111111", "3DS 1.0"),
    ]

    @IBOutlet private var cardNumberTextField: UITextField!
    @IBOutlet private var monthTextField: UITextField!
    @IBOutlet private var yearTextField: UITextField!
    @IBOutlet private var nameOnCardTextField: UITextField!
    @IBOutlet private var cvvTextField: UITextField!
    @IBOutlet private var street1TextField: UITextField!
    @IBOutlet private var street2TextField: UITextField!
    @IBOutlet private var cityTextField: UITextField!
    @IBOutlet private var countryTextField: UITextField!
    @IBOutlet private var stateTextField: UITextField!
    @IBOutlet private var zipTextField: UITextField!

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var submitButton: UIButton!
    @IBOutlet private var scrollView: UIScrollView!

    private let merchantBackend: MerchantSampleBackend = MerchantSampleBackend()
    private var activeTextField: UITextField?

    private let cardBinLength = 6

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

    func setupMerchantConfiguration() {
        PaysafeSDK.currentEnvironment = .test
        PaysafeSDK.merchantConfiguration = PaysafeSDK.MerchantConfiguration(username: "<Your Merchant User ID>",
                                                                            password: "<Your Merchant Paysafe Password>",
                                                                            accountId: "<Your Merchant Account Number>")

        PaysafeSDK.uiConfiguration = getUiConfiguration()
    }

    func getUiConfiguration() -> UIConfiguration {
        let sdkUiConfiguration = UIConfiguration()

        let toolBarConfiguration = ToolbarConfiguration()
        toolBarConfiguration.headerText = "Checkout"
        toolBarConfiguration.buttonText = "Cancel"
        toolBarConfiguration.textFont = UIFont(name: "Noteworthy", size: 18.0)
        toolBarConfiguration.textColor = "#ffffff"
        toolBarConfiguration.backgroundColor = "#080269"
        sdkUiConfiguration.toolbarConfiguration = toolBarConfiguration

        let labelConfiguration = LabelConfiguration()
        labelConfiguration.headingLabel?.textFont = UIFont(name: "Noteworthy", size: 24.0)
        labelConfiguration.headingLabel?.textColor = "#75a487"
        labelConfiguration.textFont = UIFont(name: "Noteworthy", size: 18.0)
        labelConfiguration.textColor = "#75a487"
        sdkUiConfiguration.labelConfiguration = labelConfiguration

        let textBoxConfiguration = TextBoxConfiguration()
        textBoxConfiguration.textFont = UIFont(name: "Noteworthy", size: 12.0)
        textBoxConfiguration.textColor = "#a5d6a7"
        textBoxConfiguration.borderColor = "#a5d6a7"
        textBoxConfiguration.borderWidth = 2.0
        textBoxConfiguration.cornerRadius = 8.0
        sdkUiConfiguration.textBoxConfiguration = textBoxConfiguration

        let buttonConfiguration = ButtonConfiguration()
        buttonConfiguration.textFont = UIFont(name: "Noteworthy", size: 16.0)
        buttonConfiguration.textColor = "#222222"
        buttonConfiguration.backgroundColor = "#a5d6a7"
        buttonConfiguration.cornerRadius = 4.0
        sdkUiConfiguration.setupAllButtons(withConfiguration: buttonConfiguration)

        let cancelConfiguration = ButtonConfiguration()
        cancelConfiguration.textFont = UIFont(name: "Noteworthy", size: 16.0)
        cancelConfiguration.textColor = "#ffffff"
        sdkUiConfiguration.set(buttonConfiguration: cancelConfiguration, type: .cancel)

        return sdkUiConfiguration
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        setupMerchantConfiguration()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ellipsis"),
                                                            landscapeImagePhone: nil,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapPickCard))

        cardNumberTextField.text = "4000000000001091"

        monthTextField.text = "01"
        yearTextField.text = "2022"
        nameOnCardTextField.text = "MR. JOHN SMITH"
        cvvTextField.text = "123"
        street1TextField.text = "100 Queen Street West"
        street2TextField.text = "Unit 201"
        cityTextField.text = "Toronto"
        countryTextField.text = "CA"
        stateTextField.text = "ON"
        zipTextField.text = "M5H 2N2"

        isLoading = false
    }

    func registerForKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(adjustForKeyboard(notification:)),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(adjustForKeyboard(notification:)),
                                       name: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil)
    }

    @objc private func didTapPickCard() {
        let alert = UIAlertController(title: "Pick a card",
                                      message: nil,
                                      preferredStyle: .alert)
        cards.forEach { (cardInfo) in
            alert.addAction(UIAlertAction(title: cardInfo.name,
                style: .default,
                handler: { [weak self] action in
                    self?.prefill(with: cardInfo.number)
            }))
        }
        present(alert, animated: true, completion: nil)
    }

    private func prefill(with card: String) {
        cardNumberTextField.text = card
    }

    @IBAction func didTapSubmit(_ sender: Any) {
        let expiry = Card.Expiry(month: monthTextField.text ?? "",
                                 year: yearTextField.text ?? "")

        let billingAddress = BillingAddress(street: street1TextField.text,
                                            street2: street2TextField.text,
                                            city: cityTextField.text,
                                            country: countryTextField.text ?? "",
                                            state: stateTextField.text,
                                            zip: zipTextField.text ?? "")
        let cvv = cvvTextField.text == "" ? nil : cvvTextField.text
        let card = Card(cardNumber: cardNumberTextField.text ?? "",
                        cardExpiry: expiry,
                        cvv: cvv,
                        holderName: nameOnCardTextField.text,
                        billingAddress: billingAddress)

        isLoading = true
        merchantBackend.startTransaction(card,
                                         completion: { [weak self] result in
                                            self?.isLoading = false
                                            self?.didStartTransaction(with: result)
        })
    }

    private func didStartTransaction(with result: Result<Void, Error>) {
        switch result {
        case let .failure(error):
            displayError(error)
        case .success:
            showThreeDSecureViewController()
        }
    }

    private func showThreeDSecureViewController() {
        guard let cardBin = cardNumberTextField.text?.prefix(cardBinLength) else {
            displayAlert(title: "Invalid card", message: "Invalid card number")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ThreeDSecureViewController") as! ThreeDSecureViewController
        controller.configure(cardBin: String(cardBin),
                             with: merchantBackend)
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            if #available(iOS 11.0, *) {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            } else {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            }
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset

        scrollView.scrollRectToVisible(activeTextField?.frame ?? .zero, animated: true)
    }
}

extension AddCardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            activeTextField = nil
            textField.resignFirstResponder()
        }

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}

extension UIViewController {
    func displayError(_ error: Error) {
        displayAlert(title: "Error", message: error.localizedDescription)
    }

    func displayAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

