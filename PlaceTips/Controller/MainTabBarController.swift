//
//  MainTabBarController.swift
//  PlaceTips
//
//  Created by Дмитрий Шайманов on 17.02.2022.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = .systemBlue
        
        // MARK: - Proccessing of some conditions to fix TabBar and NavigationController
        
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            
            let navBarappearance = UINavigationBarAppearance()
            navBarappearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = navBarappearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarappearance
        }

        
        // MARK: - TabBar items
        let placesView = PlacesView()
        let profileView = ProfileView()
        
        viewControllers = [
            configureNavigationViewController(rootViewController: placesView,
                                              title: "Карта",
                                              itemIcon: UIImage(systemName: "paperplane.fill")!),
            configureNavigationViewController(rootViewController: profileView,
                                              title: "Профиль",
                                              itemIcon: UIImage(systemName: "person.crop.circle")!)
            
        ]
        
        
    }
    
    // MARK: - Configure NavigationController

    private func configureNavigationViewController(rootViewController: UIViewController,
                                                   title: String,
                                                   itemIcon: UIImage) -> UIViewController
    {
        let navigationViewController = UINavigationController(rootViewController: rootViewController)
        navigationViewController.tabBarItem.title = title
        navigationViewController.tabBarItem.image = itemIcon
        return navigationViewController
    }
}
