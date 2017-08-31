//
//  ViewController.swift
//  CloudContactSDK
//
//  Created by therickys93 on 08/31/2017.
//  Copyright (c) 2017 therickys93. All rights reserved.
//

import UIKit
import CloudContactSDK

class ViewController: UIViewController {

    private var logged: Bool = false
    var user: CCUser?
    
    private struct Constants {
        static let LOGINSEGUE = "LoginSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "Cloud Contact"
        
        updateUI()
        
        // self.ccStatus()
        // self.ccRegister()
        // self.ccLogin()
    }
    
    @IBAction func logUser(segue: UIStoryboardSegue) {
        if let login = segue.source as? LoginViewController {
            self.user = login.user
            self.logged = true
            self.updateUI()
        }
    }
    
    private func updateUI() {
        userLogged()
        self.usernameLabel?.text = user?.username
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        self.logged = false
        updateUI()
    }
    
    private func userLogged() {
        if !self.logged {
            performSegue(withIdentifier: Constants.LOGINSEGUE, sender: nil)
        }
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    private func ccStatus() {
        let request = CCRequest()
        request.status { status in
            print(status.database)
            print(status.server)
        }
    }
    
    private func ccRegister() {
        let request = CCRequest()
        request.register(username: "momy", password: "12345") { user in
            print("\(user.username)")
        }
    }
    
    private func ccLogin() {
        let request = CCRequest()
        request.login(username: "momy", password: "12345") { user in
            print("\(user.username)")
        }
    }
}

