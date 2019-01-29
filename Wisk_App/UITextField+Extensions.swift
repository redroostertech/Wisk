//
//  UITextField+Extensions.swift
//  Wisk_App
//
//  Created by Michael Westbrooks on 6/17/18.
//  Copyright © 2018 redroostertechnologiesinc. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import ChameleonFramework

extension UITextField {
    
    func clearText() {
        self.text = ""
    }
    
    func addStandardPadding(withWidth width: CGFloat?,
                            andHeight height: CGFloat?,
                            toLeftSide side: Bool = true) {
        let padding = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: width ?? self.frame.width,
                                            height: height ?? self.frame.height))
        //  MARK:- Defaults to left side
        if side == true {
            self.leftView = padding
            self.leftViewMode = .always
        } else {
            self.rightView = padding
            self.rightViewMode = .always
        }
    }
}
