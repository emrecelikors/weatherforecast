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
        
        let normalTitleTextAttributes = [NSAttributedString.Key.font: UIFont.montserrat(ofSize: 10.0, style: .Semibold),
                                         NSAttributedString.Key.foregroundColor: UIColor.weatherDarkGray]
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.dodgerBlue]
        
        children.forEach { child in
            child.tabBarItem.setTitleTextAttributes(normalTitleTextAttributes,
                                                    for: .normal)
            
            child.tabBarItem.setTitleTextAttributes(selectedTitleTextAttributes,
                                                    for: .selected)
        }
    }
    
    func configureChildren() {
        
        
        if let todayViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TodayViewController") as? TodayViewController{
            if let tabbarNormalImage = UIImage(named: "TodayInactive"), let tabbarSelectedImage = UIImage(named: "TodayActive") {
                todayViewController.tabBarItem = UITabBarItem(title: "Today", image: tabbarNormalImage, selectedImage: tabbarSelectedImage)
            }
            let todayWithNavigation = BaseNavigationController(rootViewController : todayViewController)
            viewControllers = [todayWithNavigation]
        }
        
        if let forecastViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForecastViewController") as? ForecastViewController{
            if let tabbarNormalImage = UIImage(named: "ForecastInactive"), let tabbarSelectedImage = UIImage(named: "ForecastActive") {
                forecastViewController.tabBarItem = UITabBarItem(title: "Forecast", image: tabbarNormalImage, selectedImage: tabbarSelectedImage)
            }
            let forecastWithNavigation = BaseNavigationController(rootViewController : forecastViewController)
            viewControllers?.append(forecastWithNavigation)
        }
    }
}
