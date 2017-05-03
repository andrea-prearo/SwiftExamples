//
//  AppDelegate.swift
//  RegionMonitor
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 Andrea Prearo. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        requestPushNotificationPermissions(application)
        return true
    }
    
    // MARK: Private Methods
    
    func requestPushNotificationPermissions(_ application: UIApplication) {
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        application.registerForRemoteNotifications()
        UIApplication.shared.cancelAllLocalNotifications()
    }
}
