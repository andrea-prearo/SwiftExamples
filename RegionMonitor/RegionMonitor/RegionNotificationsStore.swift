//
//  RegionNotificationsStore.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 Andrea Prearo. All rights reserved.
//

import Foundation

let RegionNotificationItemsKey = "RegionNotificationItems"
let RegionNotificationItemsDidChangeNotification = "RegionNotificationItemsDidChangeNotification"

class RegionNotificationsStore {

    // MARK: Singleton

    static let sharedInstance = GenericStore<RegionNotification>(storeItemsKey: RegionNotificationItemsKey, storeItemsDidChangeNotification: RegionNotificationItemsDidChangeNotification)

}
