//
//  SQLiteConnection.swift
//  SQLiteConnectionPool
//
//  Created by Andrea Prearo on 1/20/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import Foundation
import SQLite3

public class SQLiteConnection {
    private(set) public var filename: String
    private var handle: OpaquePointer? = nil

    public init(filename: String, readonly: Bool = false) throws {
        self.filename = filename
        let flags = readonly ? SQLITE_OPEN_READONLY : SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE
        let errorCode = sqlite3_open_v2(filename, &handle, flags | SQLITE_OPEN_FULLMUTEX, nil)
        try checkSuccess(errorCode: errorCode)
    }

    public func close() throws {
        let errorCode = sqlite3_close_v2(handle)
        handle = nil
        try checkSuccess(errorCode: errorCode)
    }

    deinit {
        sqlite3_close_v2(handle)
        handle = nil
    }

    private func checkSuccess(errorCode: Int32) throws {
        if ![SQLITE_OK, SQLITE_ROW, SQLITE_DONE].contains(errorCode) {
            throw SQLiteError(errorCode: errorCode, handle: handle)
        }
    }
}

extension SQLiteConnection: Equatable {
    static public func == (lhs: SQLiteConnection, rhs: SQLiteConnection) -> Bool {
        return lhs.filename == rhs.filename
    }
}

extension SQLiteConnection: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(filename)
    }
}
