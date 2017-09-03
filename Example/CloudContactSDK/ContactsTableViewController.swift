//
//  ContactsTableViewController.swift
//  CloudContactSDK
//
//  Created by Riccardo Crippa on 8/31/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import CloudContactSDK

class ContactsTableViewController: UITableViewController {

    
    var user: CCUser? {
        didSet {
            ContactsTableViewController.saveUser(user)
        }
    }
    
    private var contacts = [CCContact]() {
        didSet {
            contacts.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending }
        }
    }
    
    private struct Constants {
        static let LOGINSEGUE = "LoginSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cloud Contact"
        updateUI()
    }
    
    @IBAction func refreshTable(segue: UIStoryboardSegue) {
        updateUI()
    }
    
    class func saveUser(_ user: CCUser?) {
        let defaults = UserDefaults.standard
        if user != nil {
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: user!), forKey: "user")
        } else {
            defaults.set(nil, forKey: "user")
        }
        defaults.synchronize()
    }
    
    class func getUser() -> CCUser? {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "user"), let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? CCUser {
            print("getUser() ok")
            return user
        } else {
            print("there is an issue")
        }
        return nil
    }
    
    @IBAction func logUser(segue: UIStoryboardSegue) {
        if let login = segue.source as? LoginViewController {
            self.user = login.user
            self.updateUI()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete pressed")
            let contact = self.contacts[indexPath.row]
            let request = CCRequest()
            request.deleteContact(contact, forUser: user!, completionHandler: { [weak self] response in
                if response {
                    print("delete ok")
                    self?.fetchContacts()
                } else {
                    print("delete failed")
                }
            })
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = self.contacts[indexPath.row]
        let path = "telprompt://\(contact.telephone)"
        let url = URL(fileURLWithPath: path)
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(URL(fileURLWithPath: path))
        } else {
            print("impossibile")
        }
    }
    */
    
    private func updateUI() {
        userLogged()
        fetchContacts()
    }
    
    @IBAction func createContact(_ sender: UIBarButtonItem) {
        createDummyContact()
    }
    
    private func createDummyContact() {
        if self.user != nil {
            let contact = CCContact(name: "test", telephone: "331", user: self.user!.id)
            let request = CCRequest()
            request.newContact(contact, forUser: user!) { [weak self] response in
                if response {
                    print("insert ok")
                    self?.fetchContacts()
                } else {
                    print("insert failed")
                }
            }
        }
    }
    
    private func fetchContacts() {
        if self.user != nil {
            let request = CCRequest()
            request.fetchContacts(forUser: user!) { [weak self] contacts in
                DispatchQueue.main.async {
                    self?.contacts = contacts
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        self.user = nil
        userLogged()
    }
    
    private func userLogged() {
        self.user = ContactsTableViewController.getUser()
        if self.user == nil {
            performSegue(withIdentifier: Constants.LOGINSEGUE, sender: nil)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let contact = self.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.telephone

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "New Contact" {
            if let _ = sender as? UIBarButtonItem {
                // from the plus button
                if let etvc = segue.destination.contents as? EditTableViewController {
                    etvc.contact = CCContact(name: "", telephone: "", user: (user?.id)!)
                    etvc.title = "New Contact"
                }
            } else if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                let contact = self.contacts[indexPath.row]
                if let etvc = segue.destination.contents as? EditTableViewController {
                    etvc.contact = contact
                    etvc.title = "Update Contact"
                    etvc.update = true
                }
            }
        }
    }
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
