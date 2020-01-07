//
//  CustomTabBarController.swift
//  FireMessenger
//
//  Created by Eyes on 2020-01-07.
//  Copyright © 2020 Eyes. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let friendsController = FriendsViewController(collectionViewLayout : layout)
        let recentmessagesNavController = UINavigationController(rootViewController: friendsController)
        recentmessagesNavController.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)
        
        var controllersToShow : [UIViewController] = []
        
        controllersToShow.append(recentmessagesNavController)
        let systemItemTags = [5,4,9,7]
        for i in systemItemTags {
            controllersToShow.append(createDummyNavControllerWithSystemItem(tag: i))
        }
        
        viewControllers = controllersToShow
    }
    
    private func createDummyNavControllerWithSystemItem(tag : Int) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        let systemBarItem = UITabBarItem.SystemItem(rawValue: tag)!
        let tabBarItem = UITabBarItem(tabBarSystemItem: systemBarItem, tag: tag)
        viewController.navigationItem.title = tabBarItem.title
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = tabBarItem
        return navController
    }
}
