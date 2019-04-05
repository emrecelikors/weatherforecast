//
//  UIView+Extension.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 5.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import UIKit

extension UIView {
    func takeScreenshot() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
    
}
