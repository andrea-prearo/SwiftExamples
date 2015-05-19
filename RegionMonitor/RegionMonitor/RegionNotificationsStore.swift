//
//  RegionNotificationsStore.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 aprearo. All rights reserved.
//

import Foundation

let RegionNotificationItemsKey = "RegionNotificationItems"
let RegionNotificationItemsDidChangeNotification = "RegionNotificationItemsDidChangeNotification"

class RegionNotificationsStore {
    private(set) internal var notifications = [RegionNotification]()

    // MARK: Singleton

    class var sharedInstance : RegionNotificationsStore {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : RegionNotificationsStore? = nil
        }

        dispatch_once(&Static.onceToken) {
            Static.instance = RegionNotificationsStore()
        }

        return Static.instance!
    }

    init() {
        loadRegionNotifications()
    }

    // MARK: Private Methods

    private func loadRegionNotifications() {
        notifications = []
        if let savedItems = NSUserDefaults.standardUserDefaults().arrayForKey(RegionNotificationItemsKey) {
            for savedItem in savedItems {
                if let annotation = NSKeyedUnarchiver.unarchiveObjectWithData(savedItem as! NSData) as? RegionNotification {
                    notifications.append(annotation)
                }
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName(RegionNotificationItemsDidChangeNotification, object: nil)
    }

    private func saveRegionNotifications() {
        var items = NSMutableArray()
        for notification in notifications {
            let item = NSKeyedArchiver.archivedDataWithRootObject(notification)
            items.addObject(item)
        }
        NSNotificationCenter.defaultCenter().postNotificationName(RegionNotificationItemsDidChangeNotification, object: nil)
        NSUserDefaults.standardUserDefaults().setObject(items, forKey: RegionNotificationItemsKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    // MARK: Public Methods

    func addRegionNotification(regionNotification: RegionNotification) {
        notifications.append(regionNotification)
        saveRegionNotifications()
    }
}
