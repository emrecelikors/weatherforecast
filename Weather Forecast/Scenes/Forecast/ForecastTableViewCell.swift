//
//  ForecastTableViewCell.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 4.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import UIKit

final class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherSummaryLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    
    func bind(_ viewModel:WeatherResponse) {
        timeLabel.text = "\(viewModel.dateString ?? "n/A")"
        weatherImageView.image = UIImage(named: viewModel.imageNameString ?? "ClearDay")
        degreeLabel.text = "\(Int(viewModel.main?.temp ?? 0.0))°"
        weatherSummaryLabel.text = viewModel.weather?.first?.description?.capitalized ?? "n/A"
    }

}
