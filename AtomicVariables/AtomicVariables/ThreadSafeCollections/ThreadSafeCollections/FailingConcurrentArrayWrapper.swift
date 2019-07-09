//
//  FailingConcurrentArrayWrapper.swift
//  ThreadSafeCollections
//
//  Created by Andrea Prearo on 1/4/19.
//  Copyright © 2019 Andrea Prearo. All rights reserved.
//

import Foundation

class FailingConcurrentArrayWrapper<T> {
    private let queue = DispatchQueue(label: "com.aprearo.FailingConcurrentArrayWrapper.queue", attributes: .concurrent)
    private var internalData = [T]()

    private(set) var getCount = 0
    private(set) var setCount = 0

    var data: [T] {
        get {
            getCount += 1
            return queue.sync { internalData }
        }
        set(newValue) {
            queue.async(flags: .barrier) { [weak self] in
                guard let self = self else { return }
                self.internalData = newValue
                self.setCount += 1
            }
        }
    }
}
