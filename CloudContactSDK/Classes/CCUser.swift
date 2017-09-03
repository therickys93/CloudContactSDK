//
//  CCUser.swift
//  Pods
//
//  Created by Riccardo Crippa on 8/31/17.
//
//

import Foundation

public class CCUser: NSObject, NSCoding {
    
    
    public required init?(coder decoder: NSCoder) {
        self._username = decoder.decodeObject(forKey: "username") as? String ?? ""
        self._id = decoder.decodeInteger(forKey: "id")
        self._key = decoder.decodeObject(forKey: "key") as? String ?? ""
        self._secret = decoder.decodeObject(forKey: "secret") as? String ?? ""
        self._password = decoder.decodeObject(forKey: "password") as? String ?? ""
    }

    public func encode(with coder: NSCoder) {
        coder.encode(username, forKey: "username")
        coder.encode(key, forKey: "key")
        coder.encode(secret, forKey: "secret")
        coder.encode(id, forKey: "id")
        coder.encode(_password, forKey: "password")
    }

    public var id: Int {
        return _id
    }
    
    public var username: String {
        return _username
    }
    
    public var key: String {
        return _key
    }
    
    public var secret: String {
        return _secret
    }
    
    private var _id: Int
    private var _username: String
    private var _password: String
    private var _key: String
    private var _secret: String
    
    init(id: Int, username: String, password: String, key: String, secret: String) {
        self._id = id
        self._username = username
        self._password = password
        self._key = key
        self._secret = secret
    }
    
}
