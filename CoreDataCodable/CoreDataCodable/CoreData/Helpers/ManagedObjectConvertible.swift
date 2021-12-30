//
//  ManagedObjectConvertible.swift
//  CoreDataCodable
//
//  Created by Andrea Prearo on 12/29/21.
//  Copyright © 2021 Andrea Prearo. All rights reserved.
//

import CoreData
import Foundation

/// Protocol to provide functionality for CoreData managed object conversion.
protocol ManagedObjectConvertible {
    associatedtype ManagedObject

    /// Converts a conforming instance to a managed object instance.
    ///
    /// - Parameter context: The managed object context to use.
    /// - Returns: The converted managed object instance.
    func toManagedObject(in context: NSManagedObjectContext) -> ManagedObject?
}
