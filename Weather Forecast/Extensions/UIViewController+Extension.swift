//
//  UIViewController+Extension.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 6.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
