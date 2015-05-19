//
//  RegionNotificationsTableViewController.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 aprearo. All rights reserved.
//

import UIKit

let RegionNotificationsTableViewCellId = "RegionNotificationsTableViewCell"

class RegionNotificationsTableViewController: UITableViewController,
    UITableViewDataSource {
    var regionNotifications: [RegionNotification]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Region Notifications", comment: "Region Notifications")

        regionNotifications = RegionNotificationsStore.sharedInstance.notifications
        regionNotifications?.sort({ $0.timestamp.timeIntervalSince1970 > $1.timestamp.timeIntervalSince1970 })

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "regionNotificationsItemsDidChange:",
            name: RegionNotificationItemsDidChangeNotification,
            object: nil)
    }

    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if regionNotifications != nil {
            return regionNotifications!.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(RegionNotificationsTableViewCellId, forIndexPath: indexPath) as! RegionNotificationCell
        let row = indexPath.row
        let regionNotification = regionNotifications?[row]
        cell.timestamp.text = regionNotification?.displayTimestamp()
        cell.status.text = regionNotification?.displayAppStatus()
        cell.message.text = regionNotification?.message
        cell.event.text = regionNotification?.displayEvent()
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            regionNotifications?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            return
        }
    }

    // MARK: NSNotificationCenter Events

    @objc func regionNotificationsItemsDidChange(notification: NSNotification) {
        regionNotifications = RegionNotificationsStore.sharedInstance.notifications
        regionNotifications?.sort({ $0.timestamp.timeIntervalSince1970 > $1.timestamp.timeIntervalSince1970 })
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}
