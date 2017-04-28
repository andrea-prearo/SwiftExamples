//
//  RegionAnnotationSettingsDetailViewController.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 Andrea Prearo. All rights reserved.
//

import UIKit
import MapKit

let RegionAnnotationMapCellId = "RegionAnnotationMapCell"
let RegionAnnotationPropertyCellId = "RegionAnnotationPropertyCell"

let RegionAnnotationSettingsDetailSegue = "RegionAnnotationSettingsDetailSegue"

let RegionAnnotationSettingMapCell = 0
let RegionAnnotationSettingCoordinateCell = 1
let RegionAnnotationSettingRasiusCell = 2

class RegionAnnotationSettingsDetailViewController: UITableViewController, MKMapViewDelegate, UITextFieldDelegate {

    var regionAnnotation: RegionAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = regionAnnotation?.title
    }

    // MARK: Private Methods
    
    func dequeueRegionAnnotationMapCell(_ indexPath: IndexPath) -> RegionAnnotationMapCell {
        return tableView.dequeueReusableCell(withIdentifier: RegionAnnotationMapCellId, for: indexPath) as! RegionAnnotationMapCell
    }

    func dequeueRegionAnnotationPropertyCell(_ indexPath: IndexPath) -> RegionAnnotationPropertyCell {
        return tableView.dequeueReusableCell(withIdentifier: RegionAnnotationPropertyCellId, for: indexPath) as! RegionAnnotationPropertyCell
    }

    func addRegionMonitoring(_ regionAnnotationMapCell: RegionAnnotationMapCell?) {
        guard let regionAnnotation = regionAnnotation else {
            return
        }

        let distance = regionAnnotation.radius * 2
        let region = MKCoordinateRegionMakeWithDistance(regionAnnotation.coordinate, distance, distance)
        regionAnnotationMapCell?.mapView.delegate = self
        regionAnnotationMapCell?.mapView.setRegion(region, animated: true)
        regionAnnotationMapCell?.mapView.addAnnotation(regionAnnotation)
        regionAnnotationMapCell?.mapView.add(MKCircle(center: regionAnnotation.coordinate, radius: regionAnnotation.radius))
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row == RegionAnnotationSettingMapCell {
            return 250.0
        } else {
            return 44.0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch (indexPath as NSIndexPath).row {
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
            print("Error: invalid indexPath for cellForRowAtIndexPath: \(indexPath)")
       }
        return cell
    }

    // MARK: MKMapViewDelegate

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            return RegionAnnotationView.circleRenderer(overlay)
        }
        return MKOverlayRenderer()
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.calloutOffset = CGPoint(x: -1000, y: -1000)
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }

}
