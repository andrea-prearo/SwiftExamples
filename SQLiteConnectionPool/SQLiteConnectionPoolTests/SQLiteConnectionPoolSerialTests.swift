//
//  SQLiteConnectionPoolSerialTests.swift
//  SQLiteConnectionPoolTests
//
//  Created by Andrea Prearo on 1/20/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import SQLiteConnectionPool
import XCTest

class SQLiteConnectionPoolSerialTests: XCTestCase {
    let iterations = 1000

    func testCreateConnections() {
        // Concurrently add 1000 SQLite connections
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            let filename = "database\(index+1)"
            let result = SQLiteConnectionPoolSerial.shared.connectToDatabase(filename: filename)
            switch result {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                case .success(let value):
                    guard let connection = value else {
                        XCTFail("\(filename) connection not found!")
                        return
                    }
                    XCTAssertEqual(connection.filename, filename)
            }

            DispatchQueue.global().sync {
                guard index >= iterations else { return }
                XCTAssertEqual(iterations, SQLiteConnectionPoolSerial.shared.connectedDatabasesCount)
            }
        }
    }

    func testRemoveConnections() {
        testCreateConnections()

        // Concurrently remove 1000 SQLite connections
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            let filename = "database\(index + 1)"
            let error = SQLiteConnectionPoolSerial.shared.disconnectFromDatabase(filename: filename)
            if let error = error {
                XCTFail(error.localizedDescription)
            }

            DispatchQueue.global().sync {
                guard index >= iterations else { return }
                XCTAssertEqual(0, SQLiteConnectionPoolSerial.shared.connectedDatabasesCount)
            }
        }
    }

    func testRemoveAllConnections() {
        testCreateConnections()

        // Remove all SQLite connections at once
        let error = SQLiteConnectionPoolSerial.shared.disconnectFromAllDatabases()
        if let error = error {
            XCTFail(error.localizedDescription)
        }
    }

    func testExistingConnection() {
        testCreateConnections()

        // Concurrently verify existing SQLite connections
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            let filename = "database\(index+1)"
            guard let connection = SQLiteConnectionPoolSerial.shared.connectedDatabase(filename: filename) else {
                XCTFail("\(filename) connection not found!")
                return
            }
            XCTAssertEqual(connection.filename, filename)
        }
    }

    func testInterspersedReads() {
        // Add and verify 1000 SQLite connections
        for index in 0..<iterations {
            let filename = "database\(index+1)"
            let result = SQLiteConnectionPoolSerial.shared.connectToDatabase(filename: filename)
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .success(let value):
                guard let connection = value else {
                    XCTFail("\(filename) connection not found!")
                    return
                }
                XCTAssertEqual(connection.filename, filename)
            }
            guard let connection = SQLiteConnectionPoolSerial.shared.connectedDatabase(filename: filename) else {
                XCTFail("\(filename) connection not found!")
                return
            }
            XCTAssertEqual(connection.filename, filename)
        }

        // Remove and verify 1000 SQLite connections
        for index in 0..<iterations {
            let filename = "database\(index + 1)"
            let error = SQLiteConnectionPoolSerial.shared.disconnectFromDatabase(filename: filename)
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            if SQLiteConnectionPoolSerial.shared.connectedDatabase(filename: filename) != nil {
                XCTFail("\(filename) connection should have been removed!")
                return
            }
        }
    }
}
