//
//  Endpoint.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 2.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation

struct Endpoint {
    
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    static func getTodaysWeather(lat: Double, lon: Double) -> Endpoint {
        return Endpoint(
            path: "/data/2.5/weather",
            queryItems: [
                URLQueryItem(name: "lat", value: lat.description),
                URLQueryItem(name: "lon", value: lon.description)
            ]
        )
    }
    
    static func getForecast(lat: Double, lon: Double) -> Endpoint {
        return Endpoint(
            path: "/data/2.5/forecast",
            queryItems: [
                URLQueryItem(name: "lat", value: lat.description),
                URLQueryItem(name: "lon", value: lon.description)
            ]
        )
    }
}

extension Endpoint {
    var commonQueryItems: [URLQueryItem] {
        return [URLQueryItem(name: "units",
                             value: "metric"),
                URLQueryItem(name: "APPID",
                             value: "7e05534c5b4a07bb260015fcfb04ae4d")]
    }
    
    var urlString: String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = path
        components.queryItems = queryItems + commonQueryItems
        return components.url?.absoluteString ?? "NOTVALIDURL"
    }
}
