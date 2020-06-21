//
//  AppDelegate.swift
//  WeatherForecast
//
//  Created by hong3 on 2020/02/22.
//  Copyright © 2020 hong3. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = WeatherViewController()
        self.window?.makeKeyAndVisible()
        
        return true
    }

}
