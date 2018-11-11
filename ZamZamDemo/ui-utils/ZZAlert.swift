//
//  ZZAlert.swift
//  ZamZamDemo
//
//  Created by Daniil Pendikov on 10/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//

import UIKit

class ZZAlert {
    
    /// Displays alert with error
    ///
    /// - Parameters:
    ///   - text: error description
    ///   - controller: presenting view controller
    class func showError(text: String, controller: UIViewController) {
        func show() {
            let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                alert.dismiss(animated: true, completion: nil)
            }))
            controller.present(alert, animated: true, completion: nil)
        }
        if controller.presentedViewController != nil {
            controller.dismiss(animated: true) {
                show()
            }
        } else {
            show()
        }
    }
    
}
