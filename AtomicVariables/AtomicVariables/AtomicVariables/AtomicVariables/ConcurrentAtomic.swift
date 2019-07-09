//
//  ConcurrentAtomic.swift
//  AtomicVariables
//
//  Created by Andrea Prearo on 1/4/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import Foundation

class ConcurrentAtomic<A> {
    private let queue = DispatchQueue(label: "com.aprearo.ConcurrentAtomic.queue", attributes: .concurrent)
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
    
    func mutate(_ transform: @escaping (inout A) -> ()) {
        queue.async(flags: .barrier) {
            transform(&self._value)
            self.setCount += 1
        }
    }
}
