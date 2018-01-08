//
//  Fetchable.swift
//  Issues
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

protocol Fetchable {
    associatedtype DataType
    func fetch(completionBlock: @escaping ([DataType]?) -> Void)
}
