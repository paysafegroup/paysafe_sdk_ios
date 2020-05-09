//
//  UIConfiguration.swift
//  Paysafe_SDK
//
//  Created by Tsvetelina Stoyanova on 18.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation
import CardinalMobile

private enum Constants {
    static let defaultCornerRadius: CGFloat = 0.0
    static let defaultBorderWidth: CGFloat = 0.0
    static let defaultFontSize: CGFloat = 12.0
}

@objcMembers public class BaseUiConfiguration: NSObject {
    public var textFont: UIFont?
    public var textColor: String?
}

/**
 Label configuration

 Customize labels by setting UIFont and color as hex code.
 Possible different configurations for standard labels and headings
 */
@objcMembers public class LabelConfiguration: BaseUiConfiguration {

    /// Possible different configurations for standart labels and headings
    public var headingLabel: BaseUiConfiguration?
}

/**
 Button configuration

 Choose `button type`. It can be:
    - *continues*
    - *cancel*
    - *resend*
    - *verify*

 Each of them can have different configuration or they can be set all at once.
 ---

 Another configurable options are:
    * `cornerRadius`
    * `backgroundColor`
    * `textFont`
    * `textColor`

 All colors are in hex format.
 ---
 */
@objcMembers public class ButtonConfiguration: BaseUiConfiguration {
    @objc(PaysafeSDKButtonConfigurationType) public enum ButtonConfigurationType: Int {
        case continues
        case cancel
        case resend
        case verify
    }

    public var buttonType: ButtonConfigurationType?
    public var cornerRadius: CGFloat = Constants.defaultCornerRadius
    public var backgroundColor: String = UIColor.clear.toHexString()
}

/**
 TextBox configuration

 Available options are:
    * `borderWidth`
    * `borderColor`
    * `cornerRadius`
    * `textFont`
    * `textColor`

 All colors are in hex format.
 ---
*/
@objcMembers public class TextBoxConfiguration: BaseUiConfiguration {
    public var borderWidth: CGFloat = Constants.defaultBorderWidth
    public var borderColor: String?
    public var cornerRadius: CGFloat = Constants.defaultCornerRadius
}

/**
 Toolbar configuration

 Available options are:
    * `buttonText`
    * `backgroundColor`
    * `headerText`
    * `textFont`
    * `textColor`

 All colors are in hex format.
 ---
 */
@objcMembers public class ToolbarConfiguration: BaseUiConfiguration {
    public var buttonText: String?
    public var backgroundColor: String?
    public var headerText: String?
}

/**
 UIConfiguration object provides values for label, textBox, toolbar and button configurations
 */
@objc(PaysafeSDKUIConfiguration) public class UIConfiguration: NSObject {
    @objc public var labelConfiguration: LabelConfiguration?
    @objc public var textBoxConfiguration: TextBoxConfiguration?
    @objc public var toolbarConfiguration: ToolbarConfiguration?

    private var cancelButtonConfiguration: ButtonConfiguration?
    private var resendButtonConfiguration: ButtonConfiguration?
    private var continueButtonConfiguration: ButtonConfiguration?
    private var verifyButtonConfiguration: ButtonConfiguration?

    /**
     Apply custom options on all available buttons according to the specified options

     - Parameter buttonConfiguration: Configuration object which containes all modifiable parameters
     */
    @objc public func setupAllButtons(withConfiguration buttonConfiguration: ButtonConfiguration) {
        cancelButtonConfiguration = buttonConfiguration
        continueButtonConfiguration = buttonConfiguration
        resendButtonConfiguration = buttonConfiguration
        verifyButtonConfiguration = buttonConfiguration
    }

    /**
     Custom button configuration.

     - Parameters:
        - buttonConfiguration: ButtonConfiguration object with set preffered style parameters.
        - type: button type which should be modified. *type* can be:
            * cancel
            * continues
            * resend
            * verify
    */
    @objc public func set(buttonConfiguration: ButtonConfiguration, type: ButtonConfiguration.ButtonConfigurationType) {
        switch type {
        case .cancel:
            cancelButtonConfiguration = buttonConfiguration
        case .continues:
            continueButtonConfiguration = buttonConfiguration
        case .resend:
            resendButtonConfiguration = buttonConfiguration
        case .verify:
            verifyButtonConfiguration = buttonConfiguration
        }
    }

    private func getCustomizedButton(for type: ButtonConfiguration.ButtonConfigurationType) -> ButtonCustomization? {
        let buttonConfiguration: ButtonConfiguration?

        switch type {
        case .cancel:
            buttonConfiguration = cancelButtonConfiguration
        case .continues:
            buttonConfiguration = continueButtonConfiguration
        case .resend:
            buttonConfiguration = resendButtonConfiguration
        case .verify:
            buttonConfiguration = verifyButtonConfiguration
        }

        guard let activeButtonConfiguration = buttonConfiguration else {
            return nil
        }

        let buttonCust = ButtonCustomization()
        buttonCust.textFontName = activeButtonConfiguration.textFont?.fontName
        buttonCust.textFontSize = Int32(activeButtonConfiguration.textFont?.pointSize ?? Constants.defaultFontSize)
        buttonCust.textColor = activeButtonConfiguration.textColor
        buttonCust.backgroundColor = activeButtonConfiguration.backgroundColor
        buttonCust.cornerRadius = Int32(activeButtonConfiguration.cornerRadius)
        return buttonCust
    }

    @objc func createCustomizedObject() -> UiCustomization {
        let customization = UiCustomization()

        if let toolbarConfiguration = toolbarConfiguration {
            let toolbarCust = ToolbarCustomization()
            toolbarCust.headerText = toolbarConfiguration.headerText
            toolbarCust.backgroundColor = toolbarConfiguration.backgroundColor
            toolbarCust.buttonText = toolbarConfiguration.buttonText
            toolbarCust.textFontName = toolbarConfiguration.textFont?.fontName
            toolbarCust.textFontSize = Int32(toolbarConfiguration.textFont?.pointSize ?? Constants.defaultFontSize)
            toolbarCust.textColor = toolbarConfiguration.textColor
            customization.setToolbar(toolbarCust)
        }

        if let cancelCust = getCustomizedButton(for: .cancel) {
            customization.setButton(cancelCust, buttonType: ButtonTypeCancel)
        }

        if let resendCust = getCustomizedButton(for: .resend) {
            customization.setButton(resendCust, buttonType: ButtonTypeResend)
        }

        if let continueCust = getCustomizedButton(for: .continues) {
            customization.setButton(continueCust, buttonType: ButtonTypeContinue)
        }

        if let verifyCust = getCustomizedButton(for: .verify) {
            customization.setButton(verifyCust, buttonType: ButtonTypeVerify)
        }

        if let labelConfiguration = labelConfiguration {
            let labelCust = LabelCustomization()
            labelCust.headingTextFontName = labelConfiguration.headingLabel?.textFont?.fontName
            labelCust.headingTextFontSize = Int32(labelConfiguration.headingLabel?.textFont?.pointSize ?? Constants.defaultFontSize)
            labelCust.headingTextColor = labelConfiguration.headingLabel?.textColor
            labelCust.textFontName = labelConfiguration.textFont?.fontName
            labelCust.textFontSize = Int32(labelConfiguration.textFont?.pointSize ?? Constants.defaultFontSize)
            labelCust.textColor = labelConfiguration.textColor
            customization.setLabel(labelCust)
        }

        if let textBoxConfiguration = textBoxConfiguration {
            let textBoxCust = TextBoxCustomization()
            textBoxCust.textFontName = textBoxConfiguration.textFont?.fontName
            textBoxCust.textFontSize = Int32(textBoxConfiguration.textFont?.pointSize ?? Constants.defaultFontSize)
            textBoxCust.textColor = textBoxConfiguration.textColor
            textBoxCust.borderWidth = Int32(textBoxConfiguration.borderWidth)
            textBoxCust.borderColor = textBoxConfiguration.borderColor
            textBoxCust.cornerRadius = Int32(textBoxConfiguration.cornerRadius)
            customization.setTextBox(textBoxCust)
        }

        return customization
    }
}
