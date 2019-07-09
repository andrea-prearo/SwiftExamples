//
//  SQLiteConnectionPoolConcurrentAsync.swift
//  SQLiteConnectionPool
//
//  Created by Andrea Prearo on 1/20/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import Foundation

public class SQLiteConnectionPoolConcurrentAsync {
    public static let shared = SQLiteConnectionPoolConcurrentAsync()

    private var connectedDatabases = Set<SQLiteConnection>()
    private var queue = DispatchQueue(label: "com.aprearo.connectionPool.concurrentQueueAsync", qos: .background, attributes: .concurrent)

    public func connectToDatabase(filename: String,
                                  completion: @escaping (SQLiteConnection?) -> Void,
                                  failure: @escaping (Error) -> Void) {
        queue.async(flags: .barrier) {
            if let database = self.connectedDatabase(filename: filename) {
                return completion(database)
            }
            do {
                let newDatabase = try SQLiteConnection(filename: filename)
                self.connectedDatabases.insert(newDatabase)
                return completion(newDatabase)
            } catch let error {
                return failure(error)
            }
        }
    }
    
    public func disconnectFromDatabase(filename: String,
                                       completion: @escaping (Bool) -> Void,
                                       failure: @escaping (Error) -> Void) {
        queue.async(flags: .barrier) {
            for database in self.connectedDatabases {
                if database.filename == filename {
                    guard let connection = self.connectedDatabases.remove(database) else { return }
                    do {
                        try connection.close()
                        return completion(true)
                    } catch let error {
                        return failure(error)
                    }
                }
            }
            return completion(false)
        }
    }
    
    public func connectedDatabase(filename: String, completion: @escaping (SQLiteConnection?) -> Void) {
        queue.sync {
            return completion(connectedDatabase(filename: filename))
        }
    }
    
    public func disconnectFromAllDatabases(completion: @escaping () -> Void,
                                           failure: @escaping (Error) -> Void) {
        queue.async(flags: .barrier) {
            self.connectedDatabases.forEach { connection in
                do {
                    try connection.close()
                } catch let error {
                    failure(error)
                }
            }
            self.connectedDatabases.removeAll()
            return completion()
        }
    }
    
    public var connectedDatabasesCount: Int {
        return queue.sync { connectedDatabases.count }
    }
    
    private func connectedDatabase(filename: String) -> SQLiteConnection? {
        let connectedDatabases = self.connectedDatabases
        for database in connectedDatabases {
            if database.filename == filename {
                return database
            }
        }
        return nil
    }
}
