//
//  Forecast.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 4.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation

struct ForecastResponse : Codable {
    let list: [WeatherResponse]
}
