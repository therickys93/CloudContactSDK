//
//  CCContact.swift
//  Pods
//
//  Created by Riccardo Crippa on 8/31/17.
//
//

import Foundation

public class CCContact {
    
    public var name: String {
        return self._name
    }
    
    public var telephone: String {
        return self._telephone
    }
    
    public var user: Int {
        return self._user
    }
    
    private var _id: Int
    private var _name: String
    private var _telephone: String
    private var _user: Int
    
    public init(name: String, telephone: String, user: Int) {
        self._id = -1
        self._name = name
        self._telephone = telephone
        self._user = user
    }
    
    
}
