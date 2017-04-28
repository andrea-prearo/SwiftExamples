//
//  GenericStore.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/25/15.
//  Copyright (c) 2015 Andrea Prearo. All rights reserved.
//

import Foundation

class GenericStore<T: NSObject> {

    fileprivate(set) internal var storedItems = [T]()
    let storeItemsKey: String
    let storeItemsDidChangeNotification: String

    // MARK: Singleton

    init(storeItemsKey: String, storeItemsDidChangeNotification: String) {
        self.storeItemsKey = storeItemsKey
        self.storeItemsDidChangeNotification = storeItemsDidChangeNotification
        loadStoredItems()
    }

    // MARK: Private Methods

    fileprivate func loadStoredItems() {
        storedItems = []
        if let items = UserDefaults.standard.array(forKey: storeItemsKey) {
            for item in items {
                if let storedItem = NSKeyedUnarchiver.unarchiveObject(with: item as! Data) as? T {
                    storedItems.append(storedItem)
                }
            }
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: storeItemsDidChangeNotification), object: nil)
    }

    private func saveStoredItems() {
        let items = NSMutableArray()
        for storedItem in storedItems {
            let item = NSKeyedArchiver.archivedData(withRootObject: storedItem)
            items.add(item)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: storeItemsDidChangeNotification), object: nil)
        UserDefaults.standard.set(items, forKey: storeItemsKey)
        UserDefaults.standard.synchronize()
    }

    // MARK: Public Methods

    func addStoredItem(_ item: T) {
        storedItems.append(item)
        saveStoredItems()
    }

    func removeStoredItem(_ item: T) {
        storedItems.remove(at: indexForItem(item))
        saveStoredItems()
    }

    func indexForItem(_ item: T) -> Int {
        var index = -1
        for storedItem in storedItems {
            if storedItem == item {
                break
            }
            index += 1
        }
        return index
    }

}
