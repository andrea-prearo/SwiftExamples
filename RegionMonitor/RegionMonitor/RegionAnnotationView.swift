//
//  RegionAnnotationView.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 aprearo. All rights reserved.
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

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupPin()
    }

    // MARK: Static Methods

    class func circleRenderer(overlay: MKOverlay) -> MKCircleRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.lineWidth = 1.0
        circleRenderer.strokeColor = UIColor.blueColor()
        circleRenderer.fillColor = UIColor.blueColor().colorWithAlphaComponent(0.4)
        return circleRenderer
    }
    
    // MARK: Private Methods

    private func setupPin() {
        pinColor = MKPinAnnotationColor.Red
        animatesDrop = true
        canShowCallout = true
        let removeButton : UIButton = UIButton(type: UIButtonType.Custom)
        removeButton.tag = RegionAnnotationViewRemoveButtonTag
        removeButton.frame = CGRectMake(0, 0, 25, 25)
        removeButton.setImage(UIImage(named: "close-icon"), forState: .Normal)
        removeButton.addTarget(self, action: nil, forControlEvents: UIControlEvents.TouchUpInside)
        leftCalloutAccessoryView =  removeButton
        let detailButton : UIButton = UIButton(type: UIButtonType.DetailDisclosure)
        detailButton.tag = RegionAnnotationViewDetailsButtonTag
        detailButton.addTarget(self, action: nil, forControlEvents: UIControlEvents.TouchUpInside)
        rightCalloutAccessoryView = detailButton
    }

    // MARK: Public Methods
    
    func addRadiusOverlay(mapView: MKMapView?) {
        let regionAnnotation = annotation as! RegionAnnotation
        mapView?.addOverlay(MKCircle(centerCoordinate: regionAnnotation.coordinate, radius: regionAnnotation.radius))
    }

    func removeRadiusOverlay(mapView: MKMapView?) {
        if let overlays = mapView?.overlays {
            for overlay in overlays {
                if let circleOverlay = overlay as? MKCircle {
                    let coord = circleOverlay.coordinate
                    let regionAnnotation = annotation as! RegionAnnotation
                    if coord.latitude == regionAnnotation.coordinate.latitude &&
                        coord.longitude == regionAnnotation.coordinate.longitude &&
                        circleOverlay.radius == regionAnnotation.radius {
                        mapView?.removeOverlay(circleOverlay)
                        break
                    }
                }
            }
        }
    }

}
