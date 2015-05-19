//
//  RegionAnnotation.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 aprearo. All rights reserved.
//

import Foundation
import MapKit

let RegionAnnotationCoordinateKey = "RegionAnnotationCoordinate"
let RegionAnnotationRadiusKey = "RegionAnnotationRadius"
let RegionAnnotationTitleKey = "RegionAnnotationTitle"
let RegionAnnotationSubtitleKey = "RegionAnnotationSubtitle"
let RegionAnnotationOnEntryMessageKey = "RegionAnnotationOnEntryMessage"
let RegionAnnotationOnExitMessageKey = "RegionAnnotationOnExitMessage"

let RegionAnnotationRadiusDefault = 1000.0
 
enum RegionAnnotationEvent: Int {
    case Entry
    case Exit
}
 
class RegionAnnotation: NSObject, MKAnnotation, NSCoding {
    let coordinate: CLLocationCoordinate2D
    let radius: CLLocationDistance
    let title: String
    let subtitle: String
    let onEntryMessage: String
    let onExitMessage: String

    init(region: CLCircularRegion) {
        coordinate = region.center
        radius = region.radius
        title = NSLocalizedString("Monitored Region", comment: "Monitored Region")
        subtitle = String(format: "C: %.3f, %.3f - R: %.3f", coordinate.latitude, coordinate.longitude, radius)
        onEntryMessage = NSLocalizedString("Monitored region entry", comment: "Monitored region entry")
        onExitMessage = NSLocalizedString("Monitored region exit", comment: "Monitored region exit")
    }

    // MARK: Getters

    var region: CLCircularRegion {
        return CLCircularRegion(center: coordinate, radius: radius, identifier: identifier)
    }

    var identifier: String {
        return String(format: "C: %f, %f - R: %f", coordinate.latitude, coordinate.longitude, radius)
    }

    // MARK: NSCoding
    
    required init(coder decoder: NSCoder) {
        let location = decoder.decodeObjectForKey(RegionAnnotationCoordinateKey) as! CLLocation
        coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        radius = decoder.decodeDoubleForKey(RegionAnnotationRadiusKey)
        title = decoder.decodeObjectForKey(RegionAnnotationTitleKey) as! String
        subtitle = decoder.decodeObjectForKey(RegionAnnotationSubtitleKey) as! String
        onEntryMessage = decoder.decodeObjectForKey(RegionAnnotationOnEntryMessageKey) as! String
        onExitMessage = decoder.decodeObjectForKey(RegionAnnotationOnExitMessageKey) as! String
    }
    
    func encodeWithCoder(coder: NSCoder) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        coder.encodeObject(location, forKey: RegionAnnotationCoordinateKey)
        coder.encodeDouble(radius, forKey: RegionAnnotationRadiusKey)
        coder.encodeObject(title, forKey: RegionAnnotationTitleKey)
        coder.encodeObject(subtitle, forKey: RegionAnnotationSubtitleKey)
        coder.encodeObject(onEntryMessage, forKey: RegionAnnotationOnEntryMessageKey)
        coder.encodeObject(onExitMessage, forKey: RegionAnnotationOnExitMessageKey)
    }

    // MARK: Public Methods

    func notificationMessageForEvent(annotationEvent: RegionAnnotationEvent) -> String? {
        switch annotationEvent {
        case .Entry:
            return onEntryMessage
        case .Exit:
            return onExitMessage
        default:
            return nil
        }
    }
 }
