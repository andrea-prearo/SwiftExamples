//
//  FailingConcurrentArrayWrapperTests.swift
//  ThreadSafeCollectionsTests
//
//  Created by Andrea Prearo on 1/4/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import XCTest
@testable import ThreadSafeCollections

class FailingConcurrentArrayWrapperTests: XCTestCase {
    private var arrayWrapper = FailingConcurrentArrayWrapper<Int>()

    func testAppend() {
        let iterations = 1000

        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            arrayWrapper.data.append(index)

            guard index >= iterations-1 else { return }
            DispatchQueue.global().sync {
                XCTAssertEqual(499500, arrayWrapper.data.reduce(0) { $0 + $1 })
                XCTAssertEqual(arrayWrapper.setCount, iterations)
                XCTAssertEqual(arrayWrapper.getCount, iterations)
                XCTAssertEqual(arrayWrapper.data.count, iterations)
            }
        }
    }

    // This will wait forever!!!
    func skipTestAppend2() {
        let iterations = 1000
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.aprearo.FailingConcurrentArrayWrapperTests.queue", attributes: .concurrent)

        for index in 0..<iterations {
            group.enter()
            queue.async(group: group) {
                self.arrayWrapper.data.append(index)
            }
            group.leave()
        }

        group.wait()

        XCTAssertEqual(499500, arrayWrapper.data.reduce(0) { $0 + $1 })
        XCTAssertEqual(arrayWrapper.setCount, iterations)
        XCTAssertEqual(arrayWrapper.getCount, iterations)
        XCTAssertEqual(arrayWrapper.data.count, iterations)
    }
}
