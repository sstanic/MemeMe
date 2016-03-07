//
//  TopTextDelegate.swift
//  MemeMe
//
//  Created by Sascha Stanic on 02.03.16.
//  Copyright © 2016 Sascha Stanic. All rights reserved.
//

import Foundation
import UIKit

class MemeTextDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
}