//
//  Task.swift
//  TaskList
//
//  Created by Andrea Prearo on 4/28/17.
//  Copyright © 2017 Andrea Prearo. All rights reserved.
//

import Foundation

enum Priority: Int {
    case unknown
    case high
    case medium
    case low
}

extension Priority {
    static func allValues() -> [Priority] {
        var count = 0
        return Array(AnyIterator {
            let value = Priority(rawValue: count)
            count += 1
            return value
        })
    }

    static func random() -> Priority {
        let values = allValues()
        let randomInt = Int(arc4random_uniform(UInt32(values.count)))
        return Priority(rawValue: randomInt) ?? .unknown
    }

    var asString: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .high:
            return "High"
        case .medium:
            return "Medium"
        case .low:
            return "Low"
        }
    }
}

struct Task {
    let name: String
    let priority: Priority
    let completed: Bool

    public init(name: String, priority: Priority, completed: Bool) {
        self.name = name
        self.priority = priority
        self.completed = completed
    }
}

extension Task: Equatable {}

func ==(lhs: Task, rhs: Task) -> Bool {
    return lhs.name == rhs.name && lhs.priority == rhs.priority
        && lhs.completed == rhs.completed
}
