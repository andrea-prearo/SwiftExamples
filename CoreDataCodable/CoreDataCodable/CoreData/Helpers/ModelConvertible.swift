//
//  ModelConvertible.swift
//  CoreDataCodable
//
//  Created by Andrea Prearo on 12/29/21.
//  Copyright © 2021 Andrea Prearo. All rights reserved.
//

import Foundation

/// Protocol to provide functionality for data model conversion.
protocol ModelConvertible {
    associatedtype Model

    /// Converts a conforming instance to a data model instance.
    ///
    /// - Returns: The converted data model instance.
    func toModel() -> Model?
}
