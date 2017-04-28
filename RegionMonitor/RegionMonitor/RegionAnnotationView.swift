//
//  RegionAnnotationView.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 Andrea Prearo. All rights reserved.
//

import Foundation
import MapKit

let RegionAnnotationViewRemoveButtonTag = 1001
let RegionAnnotationViewDetailsButtonTag = 1002

class RegionAnnotationView: MKPinAnnotationView {

    required init?(coder aDecoder: NSCoder) {
        super.init(annotation: nil, reuseIdentifier: nil)
        setupPin()
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupPin()
    }

    // MARK: Static Methods

    class func circleRenderer(_ overlay: MKOverlay) -> MKCircleRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.lineWidth = 1.0
        circleRenderer.strokeColor = UIColor.blue
        circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.4)
        return circleRenderer
    }
    
    // MARK: Private Methods

    fileprivate func setupPin() {
        pinColor = MKPinAnnotationColor.red
        animatesDrop = true
        canShowCallout = true
        let removeButton : UIButton = UIButton(type: UIButtonType.custom)
        removeButton.tag = RegionAnnotationViewRemoveButtonTag
        removeButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        removeButton.setImage(UIImage(named: "close-icon"), for: UIControlState())
        leftCalloutAccessoryView =  removeButton
        let detailButton : UIButton = UIButton(type: UIButtonType.detailDisclosure)
        detailButton.tag = RegionAnnotationViewDetailsButtonTag
        rightCalloutAccessoryView = detailButton
    }

    // MARK: Public Methods
    
    func addRadiusOverlay(_ mapView: MKMapView?) {
        let regionAnnotation = annotation as! RegionAnnotation
        mapView?.add(MKCircle(center: regionAnnotation.coordinate, radius: regionAnnotation.radius))
    }

    func removeRadiusOverlay(_ mapView: MKMapView?) {
        if let overlays = mapView?.overlays {
            for overlay in overlays {
                if let circleOverlay = overlay as? MKCircle {
                    let coord = circleOverlay.coordinate
                    let regionAnnotation = annotation as! RegionAnnotation
                    if coord.latitude == regionAnnotation.coordinate.latitude &&
                        coord.longitude == regionAnnotation.coordinate.longitude &&
                        circleOverlay.radius == regionAnnotation.radius {
                        mapView?.remove(circleOverlay)
                        break
                    }
                }
            }
        }
    }

}
