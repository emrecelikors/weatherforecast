//
//  BaseTabbarController.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 3.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureChildren()
        configureStyle()
    }
    
    func configureStyle() {
        tabBar.barTintColor = .white
        
        let normalTitleTextAttributes = [NSAttributedString.Key.font: UIFont.montserratMedium(ofSize: 10.0, style: .Semibold),
                                         NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
        
        children.forEach { child in
            child.tabBarItem.setTitleTextAttributes(normalTitleTextAttributes,
                                                    for: .normal)
            
            child.tabBarItem.setTitleTextAttributes(selectedTitleTextAttributes,
                                                    for: .selected)
        }
    }
    
    func configureChildren() {
        if let todayViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() {
            viewControllers = [todayViewController,todayViewController]
        }
    }
}
