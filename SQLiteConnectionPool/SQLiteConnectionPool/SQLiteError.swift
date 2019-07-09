//
//  SQLiteError.swift
//  SQLiteConnectionPool
//
//  Created by Andrea Prearo on 3/24/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import Foundation
import SQLite3

public class SQLiteError: LocalizedError {
    private var description: String
    
    public var errorDescription: String? {
        return description
    }
    
    public var failureReason: String? {
        return description
    }
    
    var localizedDescription: String {
        return description
    }
    
    init(errorCode: Int32, handle: OpaquePointer?) {
        description = String(cString: sqlite3_errmsg(handle))
    }
}
