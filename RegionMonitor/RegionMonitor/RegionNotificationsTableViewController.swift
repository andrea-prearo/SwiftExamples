//
//  RegionNotificationsTableViewController.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 Andrea Prearo. All rights reserved.
//

import UIKit

let RegionNotificationsTableViewCellId = "RegionNotificationsTableViewCell"

class RegionNotificationsTableViewController: UITableViewController {

    var regionNotifications: [RegionNotification]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Region Notifications", comment: "Region Notifications")

        regionNotifications = RegionNotificationsStore.sharedInstance.storedItems
        regionNotifications?.sort(by: { $0.timestamp.timeIntervalSince1970 > $1.timestamp.timeIntervalSince1970 })

        NotificationCenter.default.addObserver(self,
            selector: #selector(RegionNotificationsTableViewController.regionNotificationsItemsDidChange(_:)),
            name: NSNotification.Name(rawValue: RegionNotificationItemsDidChangeNotification),
            object: nil)
    }

    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if regionNotifications != nil {
            return regionNotifications!.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegionNotificationsTableViewCellId, for: indexPath) as! RegionNotificationCell
        let row = (indexPath as NSIndexPath).row
        let regionNotification = regionNotifications?[row]
        cell.timestamp.text = regionNotification?.displayTimestamp()
        cell.status.text = regionNotification?.displayAppStatus()
        cell.message.text = regionNotification?.message
        cell.event.text = regionNotification?.displayEvent()
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            regionNotifications?.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
        }
    }

    // MARK: NSNotificationCenter Events

    @objc func regionNotificationsItemsDidChange(_ notification: Notification) {
        regionNotifications = RegionNotificationsStore.sharedInstance.storedItems
        regionNotifications?.sort(by: { $0.timestamp.timeIntervalSince1970 > $1.timestamp.timeIntervalSince1970 })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}
