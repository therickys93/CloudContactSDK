//
//  CCRequest.swift
//  Pods
//
//  Created by Riccardo Crippa on 8/31/17.
//
//

import Foundation

struct CloudContact {
    static let BACKEND = "http://192.168.15.50:8080/"
    struct Method {
        static let GET = "GET"
        static let POST = "POST"
    }
    struct Request {
        static let LOGIN = "login"
        static let REGISTER = "register"
        static let STATUS = "status"
        static let ME = "api/me"
        static let NEWCONTACT = "api/insertContact"
        static let CONTACTS = "api/contacts"
        static let DELETECONTACT = "api/deleteContact"
        static let UPDATECONTACT = "api/updateContact"
    }
}

public class CCRequest {
    
    public init() {
        
    }
    
    public func updateContact(_ contact: CCContact, forUser user: CCUser, completionHandler handler: @escaping (Bool) -> Void) {
        makeApiRequest(CloudContact.Request.UPDATECONTACT, usingMethod: CloudContact.Method.POST, withParamenters: contact.toJsonWithID(), apiKey: user.key, apiSecret: user.secret) { response in
            if response.contains("error") {
                handler(false)
            } else {
                handler(true)
            }
        }
    }
    
    public func deleteContact(_ contact: CCContact, forUser user: CCUser, completionHandler handler: @escaping (Bool) -> Void) {
        makeApiRequest(CloudContact.Request.DELETECONTACT, usingMethod: CloudContact.Method.POST, withParamenters: contact.toJsonWithID(), apiKey: user.key, apiSecret: user.secret) { response in
            if response.contains("error") {
                handler(false)
            } else {
                handler(true)
            }
        }
    }
    
    public func fetchContacts(forUser: CCUser, completionHandler handler: @escaping ([CCContact]) -> Void) {
        makeApiRequest(CloudContact.Request.CONTACTS, usingMethod: CloudContact.Method.GET, withParamenters: nil, apiKey: forUser.key, apiSecret: forUser.secret) { response in
            var contacts = [CCContact]()
            do {
                let json = try JSONSerialization.jsonObject(with: response.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String : Any]]
                for i in 0..<json!.count {
                    let id = json?[i]["id"] as? Int
                    let name = json?[i]["name"] as? String
                    let telephone = json?[i]["telephone"] as? String
                    let user = json?[i]["demouser_id"] as? Int
                    let contact = CCContact(id: id!, name: name!, telephone: telephone!, user: user!)
                    contacts.append(contact)
                }
            } catch {
                print("\(error)")
                contacts.removeAll()
            }
            handler(contacts)
        }
    }
    
    public func newContact(_ contact: CCContact, forUser user: CCUser, completionHandler handler: @escaping (Bool) -> Void) {
        makeApiRequest(CloudContact.Request.NEWCONTACT, usingMethod: CloudContact.Method.POST, withParamenters: contact.toJsonNoID(), apiKey: user.key, apiSecret: user.secret) { response in
            if response.contains("error") {
                handler(false)
            } else {
                handler(true)
            }
        }
    }
    
    public func me(user: CCUser, completionHandler handler: @escaping (CCUser) -> Void) {
        makeApiRequest(CloudContact.Request.ME, usingMethod: CloudContact.Method.GET, withParamenters: nil, apiKey: user.key, apiSecret: user.secret) { response in
            var user = CCUser(id: -1, username: "user not registered", password: "password", key: "key", secret: "secret")
            do {
                let json = try JSONSerialization.jsonObject(with: response.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any]
                let id = json?["id"] as? Int
                let username = json?["username"] as? String
                let password = json?["password"] as? String
                let key = json?["api_key_id"] as? String
                let secret = json?["api_key_secret"] as? String
                if id != nil, username != nil, password != nil, key != nil, secret != nil {
                    user = CCUser(id: id!, username: username!, password: password!, key: key!, secret: secret!)
                }
            } catch {
                print("\(error)")
            }
            handler(user)
        }
    }
    
    public func login(username: String, password: String, completionHandler handler: @escaping (CCUser) -> Void) {
        let parameters = "username=\(username)&password=\(password)"
        makeBasicRequest(CloudContact.Request.LOGIN, usingMethod: CloudContact.Method.POST, withParameters: parameters) { response in
            var user = CCUser(id: -1, username: "user not registered", password: "password", key: "key", secret: "secret")
            do {
                let json = try JSONSerialization.jsonObject(with: response.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any]
                let id = json?["id"] as? Int
                let username = json?["username"] as? String
                let password = json?["password"] as? String
                let key = json?["api_key_id"] as? String
                let secret = json?["api_key_secret"] as? String
                if id != nil, username != nil, password != nil, key != nil, secret != nil {
                    user = CCUser(id: id!, username: username!, password: password!, key: key!, secret: secret!)
                }
            } catch {
                print("\(error)")
            }
            handler(user)
        }
    }
    
    public func register(username: String, password: String, completionHandler handler: @escaping (CCUser) -> Void) {
        let parameters = "username=\(username)&password=\(password)"
        makeBasicRequest(CloudContact.Request.REGISTER, usingMethod: CloudContact.Method.POST, withParameters: parameters) { response in
            var user = CCUser(id: -1, username: "user already registered", password: "password", key: "key", secret: "secret")
            do {
                let json = try JSONSerialization.jsonObject(with: response.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any]
                let id = json?["id"] as? Int
                let username = json?["username"] as? String
                let password = json?["password"] as? String
                let key = json?["api_key_id"] as? String
                let secret = json?["api_key_secret"] as? String
                if id != nil, username != nil, password != nil, key != nil, secret != nil {
                    user = CCUser(id: id!, username: username!, password: password!, key: key!, secret: secret!)
                }
            } catch {
                print("\(error)")
            }
            handler(user)
        }
    }
    
    public func status(completionHandler handler: @escaping (CCStatus) -> Void) {
        makeBasicRequest(CloudContact.Request.STATUS, usingMethod: CloudContact.Method.GET, withParameters: nil) { response in
            var status = CCStatus(database: false, server: false, message: "")
            do {
                let json = try JSONSerialization.jsonObject(with: response.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any]
                let server = json?["server"] as? Bool
                let database = json?["database"] as? Bool
                let message = json?["message"] as? String
                status = CCStatus(database: database!, server: server!, message: message!)
            } catch {
                print("\(error)")
            }
            handler(status)
        }
    }
    
    private func makeBasicRequest(_ request: String, usingMethod method:String, withParameters parameters: String?, completionHandler handler: @escaping (String) -> Void) {
        let url = URL(string: "\(CloudContact.BACKEND)\(request)")
        var request = URLRequest(url: url!)
        request.httpMethod = method
        request.httpBody = parameters?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                print("error: \(String(describing: error))")
                return
            }
            let result = String(data: data, encoding: .utf8)
            handler(result!)
        }
        task.resume()
    }
    
    private func makeApiRequest(_ request: String, usingMethod method: String, withParamenters parameters: Data?, apiKey key: String, apiSecret secret: String, completionHandler handler: @escaping (String) -> Void) {
        let url = URL(string: "\(CloudContact.BACKEND)\(request)")
        var request = URLRequest(url: url!)
        request.httpMethod = method
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = parameters
        let config = URLSessionConfiguration.default
        let credential = createCredential(key: key, secret: secret)
        config.httpAdditionalHeaders = ["Authorization": credential]
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error: \(String(describing: error))")
                return
            }
            let result = String(data: data, encoding: .utf8)
            print(result!)
            handler(result!)
        }
        task.resume()
    }
    
    private func createCredential(key: String, secret: String) -> String {
        let usernamePassword = "\(key):\(secret)"
        let usernamePasswordData = usernamePassword.data(using: .utf8)
        let base64 = usernamePasswordData?.base64EncodedString()
        return "Basic \(base64 ?? "ok")"
    }
    
}
