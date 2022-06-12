//
//  AppDelegate.swift
//  PlaceTips
//
//  Created by Дмитрий Шайманов on 11.02.2022.
//
// App icon was dowloaded from https://www.flaticon.com/free-icons/maps-and-location

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        self.window!.rootViewController = MainTabBarController()
        self.window!.makeKeyAndVisible()
        return true
    }
    
}
