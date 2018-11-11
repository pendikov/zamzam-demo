//
//  GTActivityIndicator.swift
//  ZamZamDemo
//
//  Created by Daniil Pendikov on 09/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//

import UIKit

fileprivate class ZZActivityIndicatorInternal: UIActivityIndicatorView {
    
}

class ZZActivityIndicator: UIView {
    
    /// Shows activity indicator in the center of view
    class func addToView(_ view: UIView) {
        self.removeFromView(view)
        let ai = ZZActivityIndicatorInternal(style: .whiteLarge)
        ai.color = UIColor.black
        view.addSubview(ai)
        ai.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        ai.startAnimating()
    }
    
    /// Removes activity indicator from view
    class func removeFromView(_ view: UIView) {
        for v in view.subviews {
            if v is ZZActivityIndicatorInternal {
                v.removeFromSuperview()
                return
            }
        }
    }
    
}
