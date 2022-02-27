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
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        // MARK: - TabBar items
        
        let citiesView = CitiesView()
        let someViewController = SomeVC(collectionViewLayout: UICollectionViewFlowLayout())

        viewControllers = [
            configureNavigationViewController(rootViewController: citiesView,title: "Photos",
                                              image: UIImage(named: "photos")!),
            configureNavigationViewController(rootViewController: someViewController,
                                              title: "Favourites",
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
