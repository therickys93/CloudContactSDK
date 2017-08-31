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
    
    private var _database: Bool
    private var _server: Bool
    
    init(database: Bool, server: Bool) {
        self._database = database
        self._server = server
    }
    
}
