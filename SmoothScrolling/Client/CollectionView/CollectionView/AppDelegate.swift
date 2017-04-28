//
//  AppDelegate.swift
//  CollectionView
//
//  Created by Andrea Prearo on 8/19/16.
//  Copyright © 2016 Andrea Prearo. All rights reserved.
//

import UIKit
import WatchdogInspector

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        TWWatchdogInspector.start()
        return true
    }
}
