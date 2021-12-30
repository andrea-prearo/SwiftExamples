//
//  DataFetcherDelegate.swift
//  CoreDataCodable
//
//  Created by Andrea Prearo on 12/29/21.
//  Copyright © 2021 Andrea Prearo. All rights reserved.
//

import Foundation

protocol DataFetcherDelegate: AnyObject {
    associatedtype CodableModel
    associatedtype ManagedObject

    typealias DataFetcherCompletion = (Result<[ManagedObject]?, Error>) -> Void

    func saveToStorage(models: [CodableModel])
    func fetchFromStorage(completion: @escaping DataFetcherCompletion)
}
