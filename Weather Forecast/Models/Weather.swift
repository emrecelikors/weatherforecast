//
//  Weather.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 2.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation
import Alamofire

struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let rain: Rain?
    let id: Int
    let name: String
    let cod: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lon, lat: Double
    init(lat : Double, lon : Double) {
        self.lon = lon
        self.lat = lat
    }
}

struct Main: Codable {
    let temp: Double
    let pressure, humidity: Double
    let tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Rain: Codable {
    private enum CodingKeys: String, CodingKey {
        case lastHour = "1h"
        case lastThreeHours = "3h"
    }
    
    let lastHour: Double?
    let lastThreeHours: Double?
}

struct Sys: Codable {
    let message: Double
    let sunrise, sunset: Double
}

struct Weather: Codable {
    
    let id: Int
    let main, description, icon: String
    
    func getWeatherImageName(dayTime : DayTime) -> String {
        var imageName = ""
        if id >= 200 && id <= 232 {
            imageName = "Thunderstorm"
        } else if id >= 521 && id <= 531 {
            imageName = "ShowerRain"
        } else if id >= 500 && id <= 531 {
            imageName = "Rain"
        } else if id >= 600 && id <= 622 {
            imageName = "Snow"
        } else if id == 701 {
            imageName = "Mist"
        } else if id == 801 {
            imageName = "FewClouds"
        } else if id == 802 {
            imageName = "ScatteredClouds"
        } else if id == 803 {
            imageName = "BrokenClouds"
        } else {
            imageName = "ClearSky"
        }
        return imageName + dayTime.rawValue
    }
}

struct Wind: Codable {
    let speed, deg: Double
}
