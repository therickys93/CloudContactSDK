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
            
        }
        return true
    }
    
    private func loginUser() {
        if self.usernameTextField.text != nil, self.passwordTextField.text != nil {
            let request = CCRequest()
            request.login(username: self.usernameTextField.text!, password: self.passwordTextField.text!, completionHandler: { [weak self] user in
                self?.user = user
                self?.performSegue(withIdentifier: "Login", sender: nil)
            })
        }
    }
    
    @IBAction func statusButton(_ sender: UIButton) {
        status()
    }
    
    private func status() {
        let request = CCRequest()
        request.status { [weak self] status in
            DispatchQueue.main.async {
                self?.displayStatus(status)
            }
        }
    }
    
    private func displayStatus(_ status: CCStatus) {
        let alert = UIAlertController(title: "Server Response", message: status.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: UIButton) {
        loginUser()
    }

    @IBAction func register(_ sender: Any) {
        registerUser()
    }
    
    private func registerUser() {
        if self.usernameTextField.text != nil, self.passwordTextField.text != nil {
            let request = CCRequest()
            request.register(username: self.usernameTextField.text!, password: self.passwordTextField.text!, completionHandler: { [weak self] user in
                self?.user = user
                self?.performSegue(withIdentifier: "Login", sender: nil)
            })
        }
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
