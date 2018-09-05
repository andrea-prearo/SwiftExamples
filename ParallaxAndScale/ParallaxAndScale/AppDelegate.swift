//
//  AppDelegate.swift
//  ParallaxAndScale
//
//  Created by Andrea Prearo on 8/31/18.
//  Copyright © 2018 Andrea Prearo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        instantiateMainViewController()
        return true
    }
}

private extension AppDelegate {
    private func instantiateMainViewController() {
        let mainViewController = MainViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }
}
