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
        set {
           self._name = newValue
        }
        get {
            return self._name
        }
    }
    
    public var telephone: String {
        set {
            self._telephone = newValue
        }
        get {
            return self._telephone
        }
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
    
    init(id: Int, name: String, telephone: String, user: Int){
        self._id = id
        self._name = name
        self._telephone = telephone
        self._user = user
    }
    
    func toJsonNoID() -> Data? {
        let json: [String: Any] = ["name": "\(self._name)",
                                   "telephone":"\(self._telephone)",
                                   "demouser_id": self._user]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        return jsonData
    }
    
    func toJsonWithID() -> Data? {
        let json: [String: Any] = ["name": "\(self._name)",
                                    "telephone":"\(self._telephone)",
                                    "demouser_id": self._user,
                                    "id": self._id]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        return jsonData
    }
    
}
