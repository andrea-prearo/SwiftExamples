//
//  SQLiteConnectionPoolTests.swift
//  SQLiteConnectionPoolTests
//
//  Created by Andrea Prearo on 1/20/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import SQLiteConnectionPool
import XCTest

class SQLiteConnectionPoolTests: XCTestCase {
    let iterations = 1000

    func testCreateConnections() {
        // Concurrently add 1000 SQLite connections
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            let filename = "database\(index+1)"
            SQLiteConnectionPool.shared.connectToDatabase(filename: filename,
                completion: { connection in
                    guard let connection = connection else {
                        XCTFail("\(filename) connection not found!")
                        return
                    }
                    XCTAssertEqual(connection.filename, filename)
                }, failure: {
                    error in XCTFail(error.localizedDescription)
                }
            )

            DispatchQueue.global().sync {
                guard index >= iterations else { return }
                XCTAssertEqual(iterations, SQLiteConnectionPool.shared.connectedDatabasesCount)
            }
        }
    }

    func testRemoveConnections() {
        testCreateConnections()

        // Concurrently remove 1000 SQLite connections
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            let filename = "database\(index+1)"
            SQLiteConnectionPool.shared.disconnectFromDatabase(filename: filename,
                completion: { success in
                    XCTAssertTrue(success)
                }, failure: {
                    error in XCTFail(error.localizedDescription)
                }
            )

            DispatchQueue.global().sync {
                guard index >= iterations else { return }
                XCTAssertEqual(0, SQLiteConnectionPool.shared.connectedDatabasesCount)
            }
        }
    }

    func testRemoveAllConnections() {
        testCreateConnections()

        // Remove all SQLite connections at once
        SQLiteConnectionPool.shared.disconnectFromAllDatabases(completion: {
                XCTAssertEqual(0, SQLiteConnectionPool.shared.connectedDatabasesCount)
            }, failure: {
                error in XCTFail(error.localizedDescription)
            }
        )
    }

    func testExistingConnection() {
        testCreateConnections()

        // Concurrently verify existing SQLite connections
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            let filename = "database\(index+1)"
            SQLiteConnectionPool.shared.connectedDatabase(filename: filename) { connection in
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
            SQLiteConnectionPool.shared.connectToDatabase(filename: filename,
                completion: { connection in
                    guard let connection = connection else {
                        XCTFail("\(filename) connection not found!")
                        return
                    }
                    XCTAssertEqual(connection.filename, filename)
                }, failure: {
                    error in XCTFail(error.localizedDescription)
                }
            )
            SQLiteConnectionPool.shared.connectedDatabase(filename: filename) { connection in
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
            SQLiteConnectionPool.shared.disconnectFromDatabase(filename: filename,
                completion: { success in
                    XCTAssertTrue(success)
                }, failure: {
                    error in XCTFail(error.localizedDescription)
                }
            )
            SQLiteConnectionPool.shared.connectedDatabase(filename: filename) { connection in
                XCTAssertNil(connection)
            }
        }
    }
}
