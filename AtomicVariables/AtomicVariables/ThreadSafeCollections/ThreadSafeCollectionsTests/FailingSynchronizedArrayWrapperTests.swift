//
//  FailingSynchronizedArrayWrapperTests.swift
//  ThreadSafeCollectionsests
//
//  Created by Andrea Prearo on 1/4/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import XCTest
@testable import ThreadSafeCollections

class FailingSynchronizedArrayWrapperTests: XCTestCase {
    private var arrayWrapper = FailingSynchronizedArrayWrapper<Int>()
    
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

    func testAppend2() {
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
