//
//  RegionAnnotationsStore.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 aprearo. All rights reserved.
//

import Foundation

let RegionAnnotationItemsKey = "RegionAnnotationItems"
let RegionAnnotationItemsDidChangeNotification = "RegionAnnotationItemsDidChangeNotification"

class RegionAnnotationsStore {
    private(set) internal var annotations = [RegionAnnotation]()

    // MARK: Singleton

    class var sharedInstance : RegionAnnotationsStore {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : RegionAnnotationsStore? = nil
        }

        dispatch_once(&Static.onceToken) {
            Static.instance = RegionAnnotationsStore()
        }

        return Static.instance!
    }

    init() {
        loadRegionAnnotations()
    }
    
    // MARK: Private Methods
    
    private func loadRegionAnnotations() {
        annotations = []
        if let savedItems = NSUserDefaults.standardUserDefaults().arrayForKey(RegionAnnotationItemsKey) {
            for savedItem in savedItems {
                if let annotation = NSKeyedUnarchiver.unarchiveObjectWithData(savedItem as! NSData) as? RegionAnnotation {
                    annotations.append(annotation)
                }
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName(RegionAnnotationItemsDidChangeNotification, object: nil)
    }

    private func saveRegionAnnotations() {
        var items = NSMutableArray()
        for annotation in annotations {
            let item = NSKeyedArchiver.archivedDataWithRootObject(annotation)
            items.addObject(item)
        }
        NSNotificationCenter.defaultCenter().postNotificationName(RegionAnnotationItemsDidChangeNotification, object: nil)
        NSUserDefaults.standardUserDefaults().setObject(items, forKey: RegionAnnotationItemsKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    // MARK: Public Methods

    func addRegionAnnotation(regionAnnotation: RegionAnnotation) {
        annotations.append(regionAnnotation)
        saveRegionAnnotations()
    }
    
    func removeRegionAnnotation(regionAnnotation: RegionAnnotation) {
        annotations.removeAtIndex(indexForRegion(regionAnnotation))
        saveRegionAnnotations()
    }

    func annotationForRegionIdentifier(identifier: String) -> RegionAnnotation? {
        for annotation in annotations {
            if annotation.identifier == identifier {
                return annotation
            }
        }
        return nil
    }
    
    func indexForRegion(regionAnnotation: RegionAnnotation) -> Int {
        var index = -1
        for annotation in annotations {
            if annotation == regionAnnotation {
                break
            }
            index++
        }
        return index
    }
}
