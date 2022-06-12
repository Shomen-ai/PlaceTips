//
//  MainTabBarController.swift
//  PlaceTips
//
//  Created by Дмитрий Шайманов on 17.02.2022.
//

import Firebase
import FirebaseAuth
import UIKit

final class MainTabBarController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        viewControllers = [
            configureNavigationViewController(rootViewController: PlacesView(),
                                              title: "Карта",
                                              itemIcon: UIImage(systemName: "map.fill")!),
            configureNavigationViewController(rootViewController: AuthorizationView(),
                                              title: "Профиль",
                                              itemIcon: UIImage(systemName: "person.crop.circle")!)
        ]
        Auth.auth().addStateDidChangeListener { _, user in
            if user == nil {
                self.viewControllers![0] = self.configureNavigationViewController(rootViewController: PlacesView(),
                                                                                  title: "Карта",
                                                                                  itemIcon: UIImage(systemName: "map.fill")!)
                self.viewControllers![1] = self.configureNavigationViewController(rootViewController: AuthorizationView(),
                                                                                  title: "Профиль",
                                                                                  itemIcon: UIImage(systemName: "person.crop.circle")!)
            } else {
                self.viewControllers![0] = self.configureNavigationViewController(rootViewController: PlacesView(),
                                                                                  title: "Карта",
                                                                                  itemIcon: UIImage(systemName: "map.fill")!)
                self.viewControllers![1] = self.configureNavigationViewController(rootViewController: ProfileView(),
                                                                                  title: "Профиль",
                                                                                  itemIcon: UIImage(systemName: "person.crop.circle")!)
            }
        }
    }

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
    }
    
    func configureTabs() {
        Auth.auth().addStateDidChangeListener { _, user in
            if user == nil {
                self.tabBarController?.setViewControllers([PlacesView(), AuthorizationView()], animated: true)
            } else {
                self.tabBarController?.setViewControllers([PlacesView(), ProfileView()], animated: true)
            }
        }
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
