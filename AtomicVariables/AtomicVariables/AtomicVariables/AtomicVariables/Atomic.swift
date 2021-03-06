//
//  Atomic.swift
//  AtomicVariables
//
//  Created by Andrea Prearo on 1/4/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import Foundation

class Atomic<A> {
    private let queue = DispatchQueue(label: "com.aprearo.SynchronizedAtomic.queue")
    private var _value: A
    
    private(set) var getCount = 0
    private(set) var setCount = 0
    
    init(_ value: A) {
        self._value = value
    }
    
    var value: A {
        get {
            getCount += 1
            return queue.sync { _value }
        }
    }

    func mutate(_ transform: (inout A) -> ()) {
        queue.sync {
            transform(&_value)
            setCount += 1
        }
    }
}
