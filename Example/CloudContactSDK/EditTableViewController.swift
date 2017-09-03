//
//  EditTableViewController.swift
//  CloudContactSDK
//
//  Created by Riccardo Crippa on 9/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import CloudContactSDK

class EditTableViewController: UITableViewController, UITextFieldDelegate {

    var contact: CCContact? {
        didSet {
            updateUI()
        }
    }
    var update: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        self.nameTextField?.text = contact?.name
        self.urlTextField?.text = contact?.telephone
    }
    
    var name: String {
        return self.nameTextField?.text ?? ""
    }
    
    var telephone: String {
        return self.urlTextField?.text ?? ""
    }
    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            self.nameTextField?.delegate = self
            self.nameTextField?.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var urlTextField: UITextField! {
        didSet {
            self.urlTextField?.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.isEmpty)! {
            return false
        }
        textField.resignFirstResponder()
        if textField == self.nameTextField {
            self.urlTextField.becomeFirstResponder()
        }
        if textField == self.urlTextField {
            performSegue(withIdentifier: "Add Contact", sender: nil)
        }
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Add Contact" {
            if name.isEmpty {
                // nome vuoto
                handleNameEmpty()
                return false
            } else {
                if telephone.isEmpty {
                    // nome ok
                    // url vuota
                    handleURLEmpty()
                    return false
                } else {
                    // nome ok
                    // url ok
                    return true
                }
            }
        } else {
            return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    private func handleNameEmpty() {
        let alert = UIAlertController(
            title: "Invalid Name",
            message: "A contact must have a name",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: { action in
                self.nameTextField?.text = alert.textFields?.first?.text
                self.urlTextField?.becomeFirstResponder()
        }))
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true, completion: nil)
    }
    
    private func handleURLEmpty() {
        let alert = UIAlertController(
            title: "Invalid Telephone",
            message: "A contact must have a telephone",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: { action in
                self.urlTextField?.text = alert.textFields?.first?.text
                self.urlTextField?.resignFirstResponder()
                // self.performSegue(withIdentifier: "Add Canto", sender: nil)
        }))
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func saveContact(_ sender: UIBarButtonItem) {
        if update {
            // aggiorna contact
            self.contact?.name = name
            self.contact?.telephone = telephone
            if let user = ContactsTableViewController.getUser(), let contact = self.contact {
                let request = CCRequest()
                // TODO: - sistemarlo!!!
                request.updateContact(contact, forUser: user, completionHandler: { [weak self] success in
                    if success {
                        self?.performSegue(withIdentifier: "Add Contact", sender: nil)
                    }
                })
            }
        } else {
            // crea contact
            self.contact?.name = name
            self.contact?.telephone = telephone
            if let user = ContactsTableViewController.getUser(), let contact = self.contact {
                let request = CCRequest()
                request.newContact(contact, forUser: user, completionHandler: { [weak self] success in
                    if success {
                        self?.performSegue(withIdentifier: "Add Contact", sender: nil)
                    }
                })
            }
        }
    }
        
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
