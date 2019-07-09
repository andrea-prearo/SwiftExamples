//
//  FailingAtomicTests.swift
//  AtomicVariablesTests
//
//  Created by Andrea Prearo on 1/4/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import XCTest
@testable import AtomicVariables

class FailingAtomicTests: XCTestCase {
    private var atomicInt = FailingAtomic<Int>(0)

    func testAppend() {
        let iterations = 1000
    
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            atomicInt.value += index

            guard index >= iterations-1 else { return }
            DispatchQueue.global().sync {
                XCTAssertEqual(499500, atomicInt.value)
                XCTAssertEqual(atomicInt.setCount, iterations)
                XCTAssertEqual(atomicInt.getCount, iterations)
            }
        }
    }
}
