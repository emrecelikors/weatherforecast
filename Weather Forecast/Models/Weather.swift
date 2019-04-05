//
//  Weather.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 2.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation
import Alamofire
import RxDataSources

struct WeatherResponse: Codable {
    let weather: [Weather]?
    let main: Main?
    let wind: Wind?
    let rain: Rain?
    var dt: Double?
    
    //For smooth scrolling ; it's calculated when model initialized
    var dateString : String?
    var imageNameString : String?
    var dayString : String
    
    enum CodingKeys: String, CodingKey {
        case weather = "weather"
        case main = "main"
        case wind = "wind"
        case rain = "rain"
        case dt = "dt"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        weather = try container.decodeIfPresent([Weather].self, forKey: .weather)
        main = try container.decodeIfPresent(Main.self, forKey: .main)
        wind = try container.decodeIfPresent(Wind.self, forKey: .wind)
        rain = try container.decodeIfPresent(Rain.self, forKey: .rain)
        dt = try container.decodeIfPresent(Double.self, forKey: .dt)
        dateString = DateManager.instance.timeIntervalToHourString(interval: dt ?? 0.0)
        imageNameString = "\(weather?.first?.getWeatherImageName() ?? "")"
        dayString = DateManager.instance.timeIntervalToReadableDayString(interval: dt ?? 0.0)
    }
}


struct Coord: Codable {
    let lon, lat: Double?
    init(lat : Double, lon : Double) {
        self.lon = lon
        self.lat = lat
    }
}

struct Main: Codable {
    let temp: Double?
    let pressure, humidity: Double?
    let tempMin, tempMax: Double?
    
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

struct Weather: Codable {
    
    let id: Int
    let main, description, icon: String?
    var detailedWeather : String?
    
    func getWeatherImageName() -> String {
        
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
        
        if icon?.last == "d" {
            return imageName + "Day"
        } else {
            return imageName + "Night"
        }
        
    }
}

struct Wind: Codable {
    let speed, deg: Double?
}
