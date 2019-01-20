//
//  SQLiteConnectionTests.swift
//  SQLiteConnectionPoolTests
//
//  Created by Andrea Prearo on 1/20/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import SQLiteConnectionPool
import XCTest

class SQLiteConnectionTests: XCTestCase {
    // Test is disabled.
    func skiptestCreateConnections() {
        var connections = [SQLiteConnection]()
        let iterations = 1000

        // Concurrently add 1000 SQLite connections
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            do {
                // Test is likely to crash here with SIGABRT.
                let filename = "database\(index+1)"
                try connections.append(SQLiteConnection(filename: filename))
            } catch let error {
                XCTFail(error.localizedDescription)
            }

            DispatchQueue.global().sync {
                guard index >= iterations else { return }
                XCTAssertEqual(iterations, connections.count)
            }
        }
    }
}
