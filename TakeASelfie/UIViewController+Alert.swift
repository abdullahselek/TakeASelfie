//
//  UIViewController+Alert.swift
//  TakeASelfie
//
//  Created by Abdullah Selek on 03.08.18.
//  Copyright © 2018 Abdullah Selek. All rights reserved.
//

import UIKit

internal extension UIViewController {

    internal func showAlertController(title: String?,
                                      message: String?,
                                      actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        for alertAction in actions {
            alertController.addAction(alertAction)
        }
        present(alertController, animated: true, completion: nil)
    }

}
