//
//  RegionAnnotationsStore.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 Andrea Prearo. All rights reserved.
//

import Foundation

let RegionAnnotationItemsKey = "RegionAnnotationItems"
let RegionAnnotationItemsDidChangeNotification = "RegionAnnotationItemsDidChangeNotification"

class RegionAnnotationsStore {

    // MARK: Singleton

    static let sharedInstance = GenericStore<RegionAnnotation>(storeItemsKey: RegionAnnotationItemsKey, storeItemsDidChangeNotification: RegionAnnotationItemsDidChangeNotification)

    class func annotationForRegionIdentifier(_ identifier: String) -> RegionAnnotation? {
        for annotation in RegionAnnotationsStore.sharedInstance.storedItems {
            if annotation.identifier == identifier {
                return annotation
            }
        }
        return nil
    }

}
