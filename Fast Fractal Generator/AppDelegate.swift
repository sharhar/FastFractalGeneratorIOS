//
//  AppDelegate.swift
//  Fast Fractal Generator
//
//  Created by Shahar Sandhaus on 6/25/17.
//  Copyright © 2017 Shahar Sandhaus. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainViewController()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        return true
    }
}
