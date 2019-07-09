//
//  SQLiteConnectionPoolConcurrentAsyncTests.swift
//  SQLiteConnectionPoolTests
//
//  Created by Andrea Prearo on 1/20/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import SQLiteConnectionPool
import XCTest

class SQLiteConnectionPoolConcurrentAsyncTests: XCTestCase {
    let iterations = 1000
    
    func testCreateConnections() {
        // Concurrently add 1000 SQLite connections
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            let filename = "database\(index+1)"
            SQLiteConnectionPoolConcurrentAsync.shared.connectToDatabase(filename: filename,
                                                          completion: { connection in
                                                            guard let connection = connection else {
                                                                XCTFail("\(filename) connection not found!")
                                                                return
                                                            }
                                                            XCTAssertEqual(connection.filename, filename)
            }, failure: {
                error in XCTFail(error.localizedDescription)
            })
            
            DispatchQueue.global().sync {
                guard index >= iterations else { return }
                XCTAssertEqual(iterations, SQLiteConnectionPoolConcurrentAsync.shared.connectedDatabasesCount)
            }
        }
    }
    
    func testRemoveConnections() {
        testCreateConnections()
        
        // Concurrently remove 1000 SQLite connections
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            let filename = "database\(index+1)"
            SQLiteConnectionPoolConcurrentAsync.shared.disconnectFromDatabase(filename: filename,
                                                               completion: { success in
                                                                XCTAssertTrue(success)
            }, failure: {
                error in XCTFail(error.localizedDescription)
            })
            
            DispatchQueue.global().sync {
                guard index >= iterations else { return }
                XCTAssertEqual(0, SQLiteConnectionPoolConcurrentAsync.shared.connectedDatabasesCount)
            }
        }
    }
    
    func testRemoveAllConnections() {
        testCreateConnections()

        let expectation = XCTestExpectation(description: "disconnectFromAllDatabases")

        // Remove all SQLite connections at once
        SQLiteConnectionPoolConcurrentAsync.shared.disconnectFromAllDatabases(completion: {
            // XCTAssertEqual(0, SQLiteConnectionPoolConcurrentAsync.shared.connectedDatabasesCount)
            // The above assertion would trigger the following error:
            // "BUG IN CLIENT OF LIBDISPATCH: dispatch_sync called on queue already owned by current thread".
            // The right/safe way to test `disconnectFromAllDatabases` is using an expectation.
            expectation.fulfill()
        }, failure: {
            error in XCTFail(error.localizedDescription)
        })

        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(0, SQLiteConnectionPoolConcurrentAsync.shared.connectedDatabasesCount)
    }
    
    func testExistingConnection() {
        testCreateConnections()
        
        // Concurrently verify existing SQLite connections
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            let filename = "database\(index+1)"
            SQLiteConnectionPoolConcurrentAsync.shared.connectedDatabase(filename: filename) { connection in
                guard let connection = connection else {
                    XCTFail("\(filename) connection not found!")
                    return
                }
                XCTAssertEqual(connection.filename, filename)
            }
        }
    }
    
    func testInterspersedReads() {
        // Add and verify 1000 SQLite connections
        for index in 0..<iterations {
            let filename = "database\(index+1)"
            SQLiteConnectionPoolConcurrentAsync.shared.connectToDatabase(filename: filename,
                                                          completion: { connection in
                                                            guard let connection = connection else {
                                                                XCTFail("\(filename) connection not found!")
                                                                return
                                                            }
                                                            XCTAssertEqual(connection.filename, filename)
            }, failure: {
                error in XCTFail(error.localizedDescription)
            })
            SQLiteConnectionPoolConcurrentAsync.shared.connectedDatabase(filename: filename) { connection in
                guard let connection = connection else {
                    XCTFail("\(filename) connection not found!")
                    return
                }
                XCTAssertEqual(connection.filename, filename)
            }
        }
        
        // Remove and verify 1000 SQLite connections
        for index in 0..<iterations {
            let filename = "database\(index+1)"
            SQLiteConnectionPoolConcurrentAsync.shared.disconnectFromDatabase(filename: filename,
                                                               completion: { success in
                                                                XCTAssertTrue(success)
            }, failure: {
                error in XCTFail(error.localizedDescription)
            })
            SQLiteConnectionPoolConcurrentAsync.shared.connectedDatabase(filename: filename) { connection in
                XCTAssertNil(connection)
            }
        }
    }
}
