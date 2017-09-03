//
//  CCStatus.swift
//  Pods
//
//  Created by Riccardo Crippa on 8/31/17.
//
//

import Foundation

public class CCStatus {
    
    public var database: Bool {
        return self._database
    }
    
    public var server: Bool {
        return self._server
    }
    
    public var message: String {
        return self._message
    }
    
    private var _database: Bool
    private var _server: Bool
    private var _message: String
    
    init(database: Bool, server: Bool, message: String) {
        self._database = database
        self._server = server
        self._message = message
    }
    
}
