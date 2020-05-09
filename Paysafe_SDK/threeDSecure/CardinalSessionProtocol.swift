//
//  CardinalSessionProtocol.swift
//  Paysafe_SDK
//
//  Created by Ivelin Davidov on 14.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

import Foundation
import CardinalMobile

protocol CardinalSessionProtocol {
    func configure(_ sessionConfig: CardinalSessionConfiguration)

    func setup(jwtString: String,
               completed didCompleteHandler: @escaping CardinalSessionSetupDidCompleteHandler,
               validated didValidateHandler: @escaping CardinalSessionSetupDidValidateHandler)

    func continueWith(transactionId: String,
                      payload: String,
                      acsUrl: String,
                      directoryServerID: CCADirectoryServerID,
                      validationDelegate: CardinalValidationDelegate)
}

extension CardinalSession: CardinalSessionProtocol {
}
