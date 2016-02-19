//
//  RegionNotification.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 aprearo. All rights reserved.
//

import Foundation
import UIKit

let RegionNotificationEventKey = "RegionNotificationEvent"
let RegionNotificationTimestampKey = "RegionNotificationTimestamp"
let RegionNotificationMessageKey = "RegionNotificationMessage"
let RegionNotificationAppStatusKey = "RegionNotificationAppStatus"

class RegionNotification: NSObject, NSCoding {
    let timestamp: NSDate
    let event: RegionAnnotationEvent
    let message: String
    let appStatus: UIApplicationState

    init(timestamp: NSDate, event: RegionAnnotationEvent, message: String, appStatus: UIApplicationState) {
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
        timestamp = decoder.decodeObjectForKey(RegionNotificationTimestampKey) as! NSDate
        event = RegionAnnotationEvent(rawValue: decoder.decodeIntegerForKey(RegionNotificationEventKey))!
        message = decoder.decodeObjectForKey(RegionNotificationMessageKey) as! String
        appStatus = UIApplicationState(rawValue: decoder.decodeIntegerForKey(RegionNotificationAppStatusKey))!
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(timestamp, forKey: RegionNotificationTimestampKey)
        coder.encodeInteger(event.rawValue, forKey: RegionNotificationEventKey)
        coder.encodeObject(message, forKey: RegionNotificationMessageKey)
        coder.encodeInteger(appStatus.rawValue, forKey: RegionNotificationAppStatusKey)
    }

    // MARK: Utility Methods

    func displayTimestamp() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter.stringFromDate(timestamp)
    }

    func displayEvent() -> String {
        switch event {
        case .Entry:
            return "Entry"
        case .Exit:
            return "Exit"
        }
    }
    
    func displayAppStatus() -> String {
        switch appStatus {
        case .Active:
            return "Active"
        case .Inactive:
            return "Inactive"
        case .Background:
            return "Background"
        }
    }
}
