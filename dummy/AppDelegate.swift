//
//  AppDelegate.swift
//  dummy
//
//  Created by Macbook Air on 25.09.2020.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().barTintColor = UIColor.systemBackground
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: UsersListView())
        window?.makeKeyAndVisible()
        
        return true
    }


}

