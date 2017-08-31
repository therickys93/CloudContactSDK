//
//  CCUser.swift
//  Pods
//
//  Created by Riccardo Crippa on 8/31/17.
//
//

import Foundation

public class CCUser {
    
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
