//
//  LoginViewController.swift
//  CloudContactSDK
//
//  Created by Riccardo Crippa on 8/31/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import CloudContactSDK

class LoginViewController: UIViewController, UITextFieldDelegate {

    var user: CCUser?
    private var username: String?
    private var password: String?
    
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            self.usernameTextField?.delegate = self
            self.usernameTextField?.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            self.passwordTextField?.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.isEmpty)! {
            return false
        }
        textField.resignFirstResponder()
        if textField == self.usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        if textField == self.passwordTextField {
            let request = CCRequest()
            request.login(username: self.usernameTextField.text!, password: self.passwordTextField.text!, completionHandler: { [weak self] user in
                self?.user = user
                self?.performSegue(withIdentifier: "Login", sender: nil)
            })
        }
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Login" {
            if username!.isEmpty {
                // nome vuoto
                print("nome vuoto")
                return false
            } else {
                if password!.isEmpty {
                    // nome ok
                    // password vuota
                    print("password vuota")
                    return false
                } else {
                    // nome ok
                    // password ok
                    return true
                }
            }
        } else {
            return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
}
