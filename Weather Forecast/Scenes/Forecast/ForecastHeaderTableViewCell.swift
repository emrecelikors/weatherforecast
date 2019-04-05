//
//  ForecastHeaderTableViewCell.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 5.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import UIKit

class ForecastHeaderTableViewCell : UITableViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    func bind(_ viewModel:WeatherResponse) {
        headerLabel.text = viewModel.dayString
    }
}
