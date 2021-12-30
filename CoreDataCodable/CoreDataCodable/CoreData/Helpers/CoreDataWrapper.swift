//
//  CoreDataWrapper.swift
//  CoreDataCodable
//
//  Created by Andrea Prearo on 12/29/21.
//  Copyright © 2021 Andrea Prearo. All rights reserved.
//

import CoreData
import Foundation
import OSLog

class CoreDataWrapper {
    typealias ContextBlock = (NSManagedObjectContext) -> Void

    private let persistentContainer: NSPersistentContainer
    private let syncContext: NSManagedObjectContext
//    private let logger = Logger()

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        syncContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        syncContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        syncContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
    }

    func atomic(_ lambdaBlock: ContextBlock) {
        guard let context = buildWritableContext() else {
//            logger.error("<CoreDataWrapper> - Cannot create writable managed object context")
            return
        }
        atomic(context: context, lambdaBlock: lambdaBlock)
    }

    func atomic(context: NSManagedObjectContext, lambdaBlock: ContextBlock) {
        context.performAndWait {
            lambdaBlock(context)
            save(context: context)
        }
    }

    private func buildWritableContext() -> NSManagedObjectContext? {
        // `syncContext` is a child context that supports writing to the Core Data
        // main context from a background thread.
        return syncContext
    }

    private func save(context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
//            logger.trace(("<CoreDataWrapper> - Saved changes."))
        } catch {
//            logger.error("<CoreDataWrapper> - Could not save changes in context: \(error)")
        }
    }
}
