//
//  MapViewController.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 aprearo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,
    MKMapViewDelegate, CLLocationManagerDelegate {
    private var isInitialCurrentLocation = true
    private let locationManager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        locationManager.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Map", comment: "Map")
        locationButton.enabled = false;
        addButton.enabled = false;

        requestLocationPermissions(locationManager)
        setupMapView()
        for annotation in RegionAnnotationsStore.sharedInstance.storedItems {
            addRegionMonitoring(annotation, shouldUpdate: false)
        }

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "regionAnnotationItemsDidChange:",
            name: RegionAnnotationItemsDidChangeNotification,
            object: nil)
    }
    
    // MARK: Private Methods

    func requestLocationPermissions(locationManager: CLLocationManager) {
        if CLLocationManager.locationServicesEnabled() {
            if #available(iOS 8.0, *) {
                locationManager.requestAlwaysAuthorization()
            } else {
                locationManager.startUpdatingLocation()
            }
        }
    }

    func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = false
    }

    func regionAnnotationForCurrentLocation() -> RegionAnnotation {
        let identifier = String(format: "%f, %f", mapView.region.center.latitude, mapView.region.center.longitude)
        let region = CLCircularRegion(center: mapView.region.center, radius: RegionAnnotationRadiusDefault, identifier: identifier)
        return RegionAnnotation(region: region)
    }

    func addRegionMonitoring(regionAnnotation: RegionAnnotation, shouldUpdate: Bool) {
        mapView.addAnnotation(regionAnnotation)
        startMonitoringGeotification(regionAnnotation)
        if shouldUpdate {
            RegionAnnotationsStore.sharedInstance.addStoredItem(regionAnnotation)
        }
    }
    
    func removeRegionMonitoring(regionAnnotation: RegionAnnotation) {
        mapView.removeAnnotation(regionAnnotation)
        locationManager.stopMonitoringForRegion(regionAnnotation.region)
        RegionAnnotationsStore.sharedInstance.removeStoredItem(regionAnnotation)
    }

    func startMonitoringGeotification(regionAnnotation: RegionAnnotation) {
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            showRegionMonitoringNotAvailableAlert()
            return
        }
        if #available(iOS 8.0, *) {
            if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
                showLocationPermissionsNotGrantedAlert()
            }
        }
        locationManager.startMonitoringForRegion(regionAnnotation.region)
    }

    func addRegionNotification(timestamp: NSDate, event: RegionAnnotationEvent, message: String, appStatus: UIApplicationState) {
        let notification = RegionNotification(timestamp: timestamp, event: event, message: message, appStatus: appStatus)
        print("Region Monitoring: \(notification.description)")
        RegionNotificationsStore.sharedInstance.addStoredItem(notification)
    }

    func handleRegionEvent(region: CLRegion, regionAnnotationEvent: RegionAnnotationEvent) {
        if let regionAnnotation = RegionAnnotationsStore.annotationForRegionIdentifier(region.identifier),
            let message = regionAnnotation.notificationMessageForEvent(regionAnnotationEvent)
            where !message.isEmpty {
            let appStatus = UIApplication.sharedApplication().applicationState
            addRegionNotification(NSDate(), event: regionAnnotationEvent, message: message, appStatus: appStatus)
            if appStatus != .Active {
                let notification = UILocalNotification()
                notification.alertBody = message
                notification.soundName = "Default";
                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            }
        }
    }
    
    func showLocationPermissionsNotGrantedAlert() {
        UIAlertView.showSimpleAlert(
            NSLocalizedString("Error", comment: "Error"),
            message: NSLocalizedString("Location Permission has not been granted", comment: "Location Permission has not been granted"))
    }

    func showRegionMonitoringNotAvailableAlert() {
        UIAlertView.showSimpleAlert(
            NSLocalizedString("Error", comment: "Error"),
            message: NSLocalizedString("Region Monitoring is not available", comment: "Region Monitoring is not available"))
    }

    func zoomToMapLocation(coordinate: CLLocationCoordinate2D?) {
        if coordinate != nil {
            let distance = RegionAnnotationRadiusDefault * 2
            let region = MKCoordinateRegionMakeWithDistance(coordinate!, distance, distance)
            mapView.setRegion(region, animated: true)
        }
    }

    // MARK: MKMapViewDelegate

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if isInitialCurrentLocation {
            zoomToMapLocation(userLocation.coordinate)
            isInitialCurrentLocation = false
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue()) {
                self.locationButton.enabled = true;
                self.addButton.enabled = true;
            }
        }
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let regionAnnotation = annotation as? RegionAnnotation,
            title = regionAnnotation.title {
            var regionView = mapView.dequeueReusableAnnotationViewWithIdentifier(title) as? RegionAnnotationView
            if regionView == nil {
                regionView = RegionAnnotationView(annotation: regionAnnotation, reuseIdentifier: title)
            } else {
                regionView!.annotation = annotation;
            }
            regionView!.addRadiusOverlay(mapView)
            return regionView;
        }
        return nil
    }

    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            return RegionAnnotationView.circleRenderer(overlay)
        }
        return MKOverlayRenderer()
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if view.isKindOfClass(RegionAnnotationView) {
            let regionAnnotation = view.annotation as? RegionAnnotation;
            if control.tag == RegionAnnotationViewDetailsButtonTag {
                performSegueWithIdentifier(RegionAnnotationSettingsDetailSegue, sender: regionAnnotation)
            } else if control.tag == RegionAnnotationViewRemoveButtonTag {
            }
        }
    }

    // MARK: CLLocationManagerDelegate

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if #available(iOS 8.0, *) {
            mapView.showsUserLocation = (status == .AuthorizedAlways)
        }
    }

    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent(region, regionAnnotationEvent: RegionAnnotationEvent.Entry)
        }
    }

    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent(region, regionAnnotationEvent: RegionAnnotationEvent.Exit)
        }
    }

    // MARK: Actions

    @IBAction func addButtonTapped(sender: AnyObject) {
        if CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            addRegionMonitoring(regionAnnotationForCurrentLocation(), shouldUpdate: true)
        } else  {
            showRegionMonitoringNotAvailableAlert()
        }
    }

    @IBAction func locationButtonTapped(sender: AnyObject) {
        zoomToMapLocation(mapView.userLocation.location?.coordinate)
    }

    // MARK: Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == RegionAnnotationSettingsDetailSegue {
            let regionAnnotation = sender as? RegionAnnotation
            let regionAnnotationSettingsDetailVC = segue.destinationViewController as? RegionAnnotationSettingsDetailViewController
            regionAnnotationSettingsDetailVC?.regionAnnotation = regionAnnotation
        }
    }

    // MARK: NSNotificationCenter Events

    @objc func regionAnnotationItemsDidChange(notification: NSNotification) {
        // ... refresh
    }
}
