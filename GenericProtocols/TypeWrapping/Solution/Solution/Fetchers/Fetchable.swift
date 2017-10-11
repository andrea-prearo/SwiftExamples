//
//  Fetchable.swift
//  Solution
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

// MARK: Type Placeholder
protocol FetchableType {}

protocol Fetchable {
    func fetch(completionBlock: @escaping (FetchableType) -> Void)
}

