
//
//  MapViewController.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 Andrea Prearo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    fileprivate var isInitialCurrentLocation = true
    fileprivate let locationManager = CLLocationManager()

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
        locationButton.isEnabled = false;
        addButton.isEnabled = false;

        requestLocationPermissions(locationManager)
        setupMapView()
        for annotation in RegionAnnotationsStore.sharedInstance.storedItems {
            addRegionMonitoring(annotation, shouldUpdate: false)
        }

        NotificationCenter.default.addObserver(self,
            selector: #selector(MapViewController.regionAnnotationItemsDidChange(_:)),
            name: NSNotification.Name(rawValue: RegionAnnotationItemsDidChangeNotification),
            object: nil)
    }
    
    // MARK: Private Methods

    func requestLocationPermissions(_ locationManager: CLLocationManager) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
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

    func addRegionMonitoring(_ regionAnnotation: RegionAnnotation, shouldUpdate: Bool) {
        mapView.addAnnotation(regionAnnotation)
        startMonitoringGeotification(regionAnnotation)
        if shouldUpdate {
            RegionAnnotationsStore.sharedInstance.addStoredItem(regionAnnotation)
        }
    }
    
    func removeRegionMonitoring(_ regionAnnotation: RegionAnnotation) {
        mapView.removeAnnotation(regionAnnotation)
        locationManager.stopMonitoring(for: regionAnnotation.region)
        RegionAnnotationsStore.sharedInstance.removeStoredItem(regionAnnotation)
    }

    func startMonitoringGeotification(_ regionAnnotation: RegionAnnotation) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showRegionMonitoringNotAvailableAlert()
            return
        }
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showLocationPermissionsNotGrantedAlert()
        }
        locationManager.startMonitoring(for: regionAnnotation.region)
    }

    func addRegionNotification(_ timestamp: Date, event: RegionAnnotationEvent, message: String, appStatus: UIApplicationState) {
        let notification = RegionNotification(timestamp: timestamp, event: event, message: message, appStatus: appStatus)
        print("Region Monitoring: \(notification.description)")
        RegionNotificationsStore.sharedInstance.addStoredItem(notification)
    }

    func handleRegionEvent(_ region: CLRegion, regionAnnotationEvent: RegionAnnotationEvent) {
        if let regionAnnotation = RegionAnnotationsStore.annotationForRegionIdentifier(region.identifier),
            let message = regionAnnotation.notificationMessageForEvent(regionAnnotationEvent), !message.isEmpty {
            let appStatus = UIApplication.shared.applicationState
            addRegionNotification(Date(), event: regionAnnotationEvent, message: message, appStatus: appStatus)
            if appStatus != .active {
                let notification = UILocalNotification()
                notification.alertBody = message
                notification.soundName = "Default";
                UIApplication.shared.presentLocalNotificationNow(notification)
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

    func zoomToMapLocation(_ coordinate: CLLocationCoordinate2D?) {
        if coordinate != nil {
            let distance = RegionAnnotationRadiusDefault * 2
            let region = MKCoordinateRegionMakeWithDistance(coordinate!, distance, distance)
            mapView.setRegion(region, animated: true)
        }
    }

    // MARK: MKMapViewDelegate

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if isInitialCurrentLocation {
            zoomToMapLocation(userLocation.coordinate)
            isInitialCurrentLocation = false
            let delay = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.locationButton.isEnabled = true;
                self.addButton.isEnabled = true;
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let regionAnnotation = annotation as? RegionAnnotation,
            let title = regionAnnotation.title {
            var regionView = mapView.dequeueReusableAnnotationView(withIdentifier: title) as? RegionAnnotationView
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

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            return RegionAnnotationView.circleRenderer(overlay)
        }
        return MKOverlayRenderer()
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if view is RegionAnnotationView {
            let regionAnnotation = view.annotation as? RegionAnnotation;
            if control.tag == RegionAnnotationViewDetailsButtonTag {
                performSegue(withIdentifier: RegionAnnotationSettingsDetailSegue, sender: regionAnnotation)
            } else if control.tag == RegionAnnotationViewRemoveButtonTag {
            }
        }
    }

    // MARK: CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .authorizedAlways)
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent(region, regionAnnotationEvent: RegionAnnotationEvent.entry)
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent(region, regionAnnotationEvent: RegionAnnotationEvent.exit)
        }
    }

    // MARK: Actions

    @IBAction func addButtonTapped(_ sender: AnyObject) {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            addRegionMonitoring(regionAnnotationForCurrentLocation(), shouldUpdate: true)
        } else  {
            showRegionMonitoringNotAvailableAlert()
        }
    }

    @IBAction func locationButtonTapped(_ sender: AnyObject) {
        zoomToMapLocation(mapView.userLocation.location?.coordinate)
    }

    // MARK: Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RegionAnnotationSettingsDetailSegue {
            let regionAnnotation = sender as? RegionAnnotation
            let regionAnnotationSettingsDetailVC = segue.destination as? RegionAnnotationSettingsDetailViewController
            regionAnnotationSettingsDetailVC?.regionAnnotation = regionAnnotation
        }
    }

    // MARK: NSNotificationCenter Events

    @objc func regionAnnotationItemsDidChange(_ notification: Notification) {
        // ... refresh
    }

}
