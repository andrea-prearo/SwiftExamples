//
//  SQLiteConnectionPoolSerial.swift
//  SQLiteConnectionPool
//
//  Created by Andrea Prearo on 1/20/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import Foundation

public class SQLiteConnectionPoolSerial {
    public static let shared = SQLiteConnectionPoolSerial()

    private var connectedDatabases = Set<SQLiteConnection>()
    private var queue = DispatchQueue(label: "com.aprearo.connectionPool.serialuQueue")

    public func connectToDatabase(filename: String) -> Result<SQLiteConnection?, Error> {
        if let database = self.connectedDatabase(filename: filename) {
            return .success(database)
        }

        var value: SQLiteConnection?
        var error: Error?
        queue.sync {
            do {
                let newDatabase = try SQLiteConnection(filename: filename)
                self.connectedDatabases.insert(newDatabase)
                value = newDatabase
            } catch let localError {
                error = localError
            }
        }
        if let error = error {
            return .failure(error)
        }
        return .success(value)
    }
    
    public func disconnectFromDatabase(filename: String) -> Error? {
        var error: Error?
        queue.sync {
            for database in self.connectedDatabases {
                if database.filename == filename {
                    guard let connection = self.connectedDatabases.remove(database) else { return }
                    do {
                        try connection.close()
                    } catch let localError {
                        error = localError
                    }
                }
            }
        }
        return error
    }
    
    public func connectedDatabase(filename: String) -> SQLiteConnection? {
        return queue.sync {
            let connectedDatabases = self.connectedDatabases
            for database in connectedDatabases {
                if database.filename == filename {
                    return database
                }
            }
            return nil
        }
    }
    
    public func disconnectFromAllDatabases() -> Error? {
        var error: Error?
        queue.sync {
            self.connectedDatabases.forEach { connection in
                do {
                    try connection.close()
                } catch let localError {
                    error = localError
                }
            }
            self.connectedDatabases.removeAll()
        }
        return error
    }
    
    public var connectedDatabasesCount: Int {
        return queue.sync { connectedDatabases.count }
    }
}
