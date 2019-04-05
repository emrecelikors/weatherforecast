//
//  BaseNavigationViewController.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 3.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = .white
        
        if let shadowImage = UIImage(named: "TopLineColorful") {
            self.navigationBar.shadowImage = shadowImage
        }
        
        let titleTextAttributes = [NSAttributedString.Key.font: UIFont.montserrat(ofSize: 16.0, style: .Medium),
                                   NSAttributedString.Key.foregroundColor: UIColor.weatherDarkGray]
        navigationBar.titleTextAttributes = titleTextAttributes
    }
}
