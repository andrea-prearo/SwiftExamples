//
//  ThreadSafeIssuesTests.swift
//  ThreadSafeCollectionsests
//
//  Created by Andrea Prearo on 1/4/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import XCTest

class ThreadSafeIssuesTests: XCTestCase {
    // Test is disabled.
    func skipTestCrash() {
        var array = [Int]()
        let iterations = 1000

        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            // Test is likely to crash here with SIGABRT.
            array.append(index)

            guard index >= iterations-1 else { return }
            DispatchQueue.global().sync {
                XCTAssertEqual(array.count, iterations)
            }
        }
    }
}
