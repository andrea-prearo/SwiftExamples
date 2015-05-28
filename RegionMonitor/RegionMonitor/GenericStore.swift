//
//  GenericStore.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/25/15.
//  Copyright (c) 2015 aprearo. All rights reserved.
//

import Foundation

class GenericStore<T: NSObject> {
    private(set) internal var storedItems = [T]()
    let storeItemsKey: String
    let storeItemsDidChangeNotification: String

    // MARK: Singleton

    init(storeItemsKey: String, storeItemsDidChangeNotification: String) {
        self.storeItemsKey = storeItemsKey
        self.storeItemsDidChangeNotification = storeItemsDidChangeNotification
        loadStoredItems()
    }

    // MARK: Private Methods

    private func loadStoredItems() {
        storedItems = []
        if let items = NSUserDefaults.standardUserDefaults().arrayForKey(storeItemsKey) {
            for item in items {
                if let storedItem = NSKeyedUnarchiver.unarchiveObjectWithData(item as! NSData) as? T {
                    storedItems.append(storedItem)
                }
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName(storeItemsDidChangeNotification, object: nil)
    }

    private func saveStoredItems() {
        var items = NSMutableArray()
        for storedItem in storedItems {
            let item = NSKeyedArchiver.archivedDataWithRootObject(storedItem) as? T
            items.addObject(item!)
        }
        NSNotificationCenter.defaultCenter().postNotificationName(storeItemsDidChangeNotification, object: nil)
        NSUserDefaults.standardUserDefaults().setObject(items, forKey: storeItemsKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    // MARK: Public Methods

    func addStoredItem(item: T) {
        storedItems.append(item)
        saveStoredItems()
    }

    func removeStoredItem(item: T) {
        storedItems.removeAtIndex(indexForItem(item))
        saveStoredItems()
    }

    func indexForItem(item: T) -> Int {
        var index = -1
        for storedItem in storedItems {
            if storedItem == item {
                break
            }
            index++
        }
        return index
    }
}
