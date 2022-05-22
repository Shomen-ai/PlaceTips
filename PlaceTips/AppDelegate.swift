//
//  AppDelegate.swift
//  PlaceTips
//
//  Created by Дмитрий Шайманов on 11.02.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        self.window!.rootViewController = MainTabBarController()
        self.window!.makeKeyAndVisible()

        return true
    }
}
