//
//  ConcurrentAtomicTests.swift
//  AtomicVariablesTests
//
//  Created by Andrea Prearo on 1/4/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import XCTest
@testable import AtomicVariables

class ConcurrentAtomicTests: XCTestCase {
    func testInt() {
        let atomicInt = ConcurrentAtomic<Int>(0)
        let iterations = 1000

        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            atomicInt.mutate { $0 += index }

            guard index >= iterations-1 else { return }
            DispatchQueue.global().sync {
                XCTAssertEqual(499500, atomicInt.value)
                XCTAssertEqual(atomicInt.setCount, iterations)
                XCTAssertEqual(atomicInt.getCount, 1)
            }
        }
    }

    func testAppend() {
        let atomicArray = ConcurrentAtomic<[Int]>([])
        let iterations = 1000

        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            atomicArray.mutate { $0.append(index) }

            guard index >= iterations-1 else { return }
            DispatchQueue.global().sync {
//                XCTAssertEqual(atomicArray.value.count, iterations)
                XCTAssertEqual(499500, atomicArray.value.reduce(0) { $0 + $1 })
                XCTAssertEqual(atomicArray.setCount, iterations)
                XCTAssertEqual(atomicArray.getCount, 1)
            }
        }
    }

    func testAppend2() {
        let atomicArray = ConcurrentAtomic<[Int]>([])
        let iterations = 1000
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.aprearo.AtomicTests.queue", attributes: .concurrent)

        for index in 0..<iterations {
            group.enter()
            queue.async(group: group) {
                atomicArray.mutate { $0.append(index) }
            }
            group.leave()
        }

        group.wait()

        XCTAssertEqual(atomicArray.value.count, iterations)
        XCTAssertEqual(499500, atomicArray.value.reduce(0) { $0 + $1 })
        XCTAssertEqual(atomicArray.setCount, iterations)
        XCTAssertEqual(atomicArray.getCount, 2)
    }
}
