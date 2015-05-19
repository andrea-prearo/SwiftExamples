//
//  RegionAnnotationSettingsDetailViewController.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 aprearo. All rights reserved.
//

import UIKit
import MapKit

let RegionAnnotationSettingsDetailSegue = "RegionAnnotationSettingsDetailSegue"

let RegionAnnotationSettingMapCell = 0
let RegionAnnotationSettingCoordinateCell = 1
let RegionAnnotationSettingRasiusCell = 2

class RegionAnnotationSettingsDetailViewController: UITableViewController,
    UITableViewDataSource, MKMapViewDelegate, UITextFieldDelegate {
    var regionAnnotation: RegionAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = regionAnnotation?.title
    }

    // MARK: Private Methods
    
    func dequeueRegionAnnotationMapCell(indexPath: NSIndexPath) -> RegionAnnotationMapCell {
        return tableView.dequeueReusableCellWithIdentifier("RegionAnnotationMapCell", forIndexPath: indexPath) as! RegionAnnotationMapCell
    }

    func dequeueRegionAnnotationPropertyCell(indexPath: NSIndexPath) -> RegionAnnotationPropertyCell {
        return tableView.dequeueReusableCellWithIdentifier("RegionAnnotationPropertyCell", forIndexPath: indexPath) as! RegionAnnotationPropertyCell
    }

    func addRegionMonitoring(regionAnnotationMapCell: RegionAnnotationMapCell?) {
        let distance = regionAnnotation!.radius * 2
        let region = MKCoordinateRegionMakeWithDistance(regionAnnotation!.coordinate, distance, distance)
        regionAnnotationMapCell?.mapView.delegate = self
        regionAnnotationMapCell?.mapView.setRegion(region, animated: true)
        regionAnnotationMapCell?.mapView.addAnnotation(regionAnnotation)
        regionAnnotationMapCell?.mapView.addOverlay(MKCircle(centerCoordinate: regionAnnotation!.coordinate, radius: regionAnnotation!.radius))
    }

    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == RegionAnnotationSettingMapCell {
            return 250.0
        } else {
            return 44.0
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch indexPath.row {
        case RegionAnnotationSettingMapCell:
            let regionAnnotationMapCell = dequeueRegionAnnotationMapCell(indexPath)
            addRegionMonitoring(regionAnnotationMapCell)
            cell = regionAnnotationMapCell
        case RegionAnnotationSettingCoordinateCell:
            let regionAnnotationPropertyCell = dequeueRegionAnnotationPropertyCell(indexPath)
            regionAnnotationPropertyCell.propertyLabel.text = "Coordinate"
            let coordinate = regionAnnotation?.coordinate
            regionAnnotationPropertyCell.valueTextField.text = String(format: "%f, %f", coordinate!.latitude, coordinate!.longitude)
            regionAnnotationPropertyCell.valueTextField.delegate = self
            cell = regionAnnotationPropertyCell
        case RegionAnnotationSettingRasiusCell:
            let regionAnnotationPropertyCell = dequeueRegionAnnotationPropertyCell(indexPath)
            regionAnnotationPropertyCell.propertyLabel.text = "Radius"
            regionAnnotationPropertyCell.valueTextField.text = String("\(regionAnnotation!.radius)")
            regionAnnotationPropertyCell.valueTextField.delegate = self
            cell = regionAnnotationPropertyCell
        default:
            cell = UITableViewCell()
            println("Error: invalid indexPath for cellForRowAtIndexPath: \(indexPath)")
       }
        return cell
    }

    // MARK: MKMapViewDelegate

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            return RegionAnnotationView.circleRenderer(overlay)
        }
        return nil
    }

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        view.calloutOffset = CGPointMake(-1000, -1000)
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
}
