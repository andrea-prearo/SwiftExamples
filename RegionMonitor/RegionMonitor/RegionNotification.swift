//
//  RegionNotification.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 Andrea Prearo. All rights reserved.
//

import Foundation
import UIKit

let RegionNotificationEventKey = "RegionNotificationEvent"
let RegionNotificationTimestampKey = "RegionNotificationTimestamp"
let RegionNotificationMessageKey = "RegionNotificationMessage"
let RegionNotificationAppStatusKey = "RegionNotificationAppStatus"

class RegionNotification: NSObject, NSCoding {

    let timestamp: Date
    let event: RegionAnnotationEvent
    let message: String
    let appStatus: UIApplicationState

    init(timestamp: Date, event: RegionAnnotationEvent, message: String, appStatus: UIApplicationState) {
        self.timestamp = timestamp
        self.event = event
        self.message = message
        self.appStatus = appStatus
    }

    override var description: String {
        return "Timestamp=\(displayTimestamp()), Event=\(displayEvent()), Message=\(message), App Status=\(displayAppStatus())"
    }

    // MARK: NSCoding

    required init?(coder decoder: NSCoder) {
        timestamp = decoder.decodeObject(forKey: RegionNotificationTimestampKey) as! Date
        event = RegionAnnotationEvent(rawValue: decoder.decodeInteger(forKey: RegionNotificationEventKey))!
        message = decoder.decodeObject(forKey: RegionNotificationMessageKey) as! String
        appStatus = UIApplicationState(rawValue: decoder.decodeInteger(forKey: RegionNotificationAppStatusKey))!
    }

    func encode(with coder: NSCoder) {
        coder.encode(timestamp, forKey: RegionNotificationTimestampKey)
        coder.encode(event.rawValue, forKey: RegionNotificationEventKey)
        coder.encode(message, forKey: RegionNotificationMessageKey)
        coder.encode(appStatus.rawValue, forKey: RegionNotificationAppStatusKey)
    }

    // MARK: Utility Methods

    func displayTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        return dateFormatter.string(from: timestamp)
    }

    func displayEvent() -> String {
        switch event {
        case .entry:
            return "Entry"
        case .exit:
            return "Exit"
        }
    }
    
    func displayAppStatus() -> String {
        switch appStatus {
        case .active:
            return "Active"
        case .inactive:
            return "Inactive"
        case .background:
            return "Background"
        }
    }

}
