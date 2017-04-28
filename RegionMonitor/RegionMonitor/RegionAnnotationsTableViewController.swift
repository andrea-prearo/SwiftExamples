//
//  RegionAnnotationsTableViewController.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 Andrea Prearo. All rights reserved.
//

import UIKit

let RegionAnnotationsTableViewCellId = "RegionAnnotationsTableViewCell"

class RegionAnnotationsTableViewController: UITableViewController {

    var regionAnnotations: [RegionAnnotation]?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Monitored Regions", comment: "Monitored Regions")

        regionAnnotations = RegionAnnotationsStore.sharedInstance.storedItems

        NotificationCenter.default.addObserver(self,
            selector: #selector(RegionAnnotationsTableViewController.regionAnnotationItemsDidChange(_:)),
            name: NSNotification.Name(rawValue: RegionAnnotationItemsDidChangeNotification),
            object: nil)
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if regionAnnotations != nil {
            return regionAnnotations!.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegionAnnotationsTableViewCellId, for: indexPath) 
        let row = (indexPath as NSIndexPath).row
        let regionAnnotation = regionAnnotations?[row]
        cell.textLabel?.text = regionAnnotation?.subtitle
        cell.detailTextLabel?.text = String(format: NSLocalizedString("Region \(row+1)", comment: "Region {number}"));
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            regionAnnotations?.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
        }
    }

    // MARK: Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RegionAnnotationSettingsDetailSegue {
            let cell = sender as? UITableViewCell
            let indexPath = tableView.indexPath(for: cell!)
            let regionAnnotation = regionAnnotations?[(indexPath! as NSIndexPath).row]
            let regionAnnotationSettingsDetailVC = segue.destination as? RegionAnnotationSettingsDetailViewController
            regionAnnotationSettingsDetailVC?.regionAnnotation = regionAnnotation
        }
    }

    // MARK: Actions

    @IBAction func editButtonTapped(_ sender: AnyObject) {
        tableView.isEditing = !tableView.isEditing
    }

    // MARK: NSNotificationCenter Events

    @objc func regionAnnotationItemsDidChange(_ notification: Notification) {
        regionAnnotations = RegionAnnotationsStore.sharedInstance.storedItems
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}
