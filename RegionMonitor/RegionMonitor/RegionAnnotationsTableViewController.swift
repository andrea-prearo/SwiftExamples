//
//  RegionAnnotationsTableViewController.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 aprearo. All rights reserved.
//

import UIKit

let RegionAnnotationsTableViewCellId = "RegionAnnotationsTableViewCell"

class RegionAnnotationsTableViewController: UITableViewController,
    UITableViewDataSource {
    var regionAnnotations: [RegionAnnotation]?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Monitored Regions", comment: "Monitored Regions")

        regionAnnotations = RegionAnnotationsStore.sharedInstance.storedItems

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "regionAnnotationItemsDidChange:",
            name: RegionAnnotationItemsDidChangeNotification,
            object: nil)
    }

    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if regionAnnotations != nil {
            return regionAnnotations!.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(RegionAnnotationsTableViewCellId, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        let regionAnnotation = regionAnnotations?[row]
        cell.textLabel?.text = regionAnnotation?.subtitle
        cell.detailTextLabel?.text = String(format: NSLocalizedString("Region \(row+1)", comment: "Region {number}"));
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            regionAnnotations?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            return
        }
    }

    // MARK: Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == RegionAnnotationSettingsDetailSegue {
            let cell = sender as? UITableViewCell
            let indexPath = tableView.indexPathForCell(cell!)
            let regionAnnotation = regionAnnotations?[indexPath!.row]
            var regionAnnotationSettingsDetailVC = segue.destinationViewController as? RegionAnnotationSettingsDetailViewController
            regionAnnotationSettingsDetailVC?.regionAnnotation = regionAnnotation
        }
    }

    // MARK: Actions

    @IBAction func editButtonTapped(sender: AnyObject) {
        tableView.editing = !tableView.editing
    }

    // MARK: NSNotificationCenter Events

    @objc func regionAnnotationItemsDidChange(notification: NSNotification) {
        regionAnnotations = RegionAnnotationsStore.sharedInstance.storedItems
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}
