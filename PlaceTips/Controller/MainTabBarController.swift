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
        view.backgroundColor = .gray
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
        
        let citiesView = CitiesView()
        let PlacesView = PlacesView()

        viewControllers = [
            configureNavigationViewController(rootViewController: citiesView,title: "Города",
                                              image: UIImage(named: "city")!),
            configureNavigationViewController(rootViewController: PlacesView,
                                              title: "Избранное",
                                              image: UIImage(named: "favourites")!)
        ]
    }
    
    // MARK: - Configure NavigationController

    private func configureNavigationViewController(rootViewController: UIViewController,
                                                   title: String,
                                                   image: UIImage) -> UIViewController
    {
        let navigationViewController = UINavigationController(rootViewController: rootViewController)
        navigationViewController.tabBarItem.title = title
        navigationViewController.tabBarItem.image = image
        return navigationViewController
    }
}
