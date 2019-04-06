//
//  BaseIndicatorView.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 5.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import UIKit

class BaseIndicatorView {
    
    static let instance = BaseIndicatorView()
    
    var indicatorView = UIView(frame: CGRect.zero)
    
    private init() {
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            
            
            topController.view.addSubview(indicatorView)
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            indicatorView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
            indicatorView.layer.cornerRadius = 5.0
            indicatorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            indicatorView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            indicatorView.centerXAnchor.constraint(equalTo: topController.view.centerXAnchor).isActive = true
            indicatorView.centerYAnchor.constraint(equalTo: topController.view.centerYAnchor).isActive = true
            
            let indicator = UIActivityIndicatorView(style: .white)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.startAnimating()
            indicatorView.addSubview(indicator)
            indicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
            indicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
            indicator.centerXAnchor.constraint(equalTo: indicatorView.centerXAnchor).isActive = true
            indicator.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor).isActive = true
            
        }
        
        
    }
    
}

