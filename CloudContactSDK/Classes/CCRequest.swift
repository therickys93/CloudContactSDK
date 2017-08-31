//
//  CCRequest.swift
//  Pods
//
//  Created by Riccardo Crippa on 8/31/17.
//
//

import Foundation

struct CloudContact {
    static let BACKEND = "http://localhost:8080/"
    struct Method {
        static let GET = "GET"
        static let POST = "POST"
    }
    struct Request {
        static let LOGIN = "login"
        static let REGISTER = "register"
        static let STATUS = "status"
    }
}

public class CCRequest {
    
    public init() {
        
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
            var status = CCStatus(database: false, server: false)
            do {
                let json = try JSONSerialization.jsonObject(with: response.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any]
                let server = json?["server"] as? Bool
                let database = json?["database"] as? Bool
                status = CCStatus(database: database!, server: server!)
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
    
}
