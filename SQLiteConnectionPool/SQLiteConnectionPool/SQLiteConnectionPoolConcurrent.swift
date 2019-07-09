//
//  SQLiteConnectionPoolConcurrent.swift
//  SQLiteConnectionPool
//
//  Created by Andrea Prearo on 1/20/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import Foundation

public class SQLiteConnectionPoolConcurrent {
    public static let shared = SQLiteConnectionPoolConcurrent()
    
    private var connectedDatabases = Set<SQLiteConnection>()
    private var queue = DispatchQueue(label: "com.aprearo.connectionPool.concurrentQueue", qos: .background, attributes: .concurrent)

    public func connectToDatabase(filename: String) -> Result<SQLiteConnection?, Error> {
        if let database = self.connectedDatabase(filename: filename) {
            return .success(database)
        }
        
        var value: SQLiteConnection?
        var error: Error?
        queue.sync(flags: .barrier) {
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
        queue.sync(flags: .barrier) {
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
        queue.sync(flags: .barrier) {
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
