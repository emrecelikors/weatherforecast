//
//  UIFont+Extension.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 3.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import UIKit

extension UIFont {
    class func montserrat(ofSize size: CGFloat , style : MontserratStyle = .Medium ) -> UIFont {
        return UIFont(name: "Montserrat-\(style.rawValue)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

enum MontserratStyle : String {
    case Medium = "Medium"
    case Semibold = "Semibold"
    case Light = "Light"
}
