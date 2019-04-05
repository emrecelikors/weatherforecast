//
//  DataManager.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 4.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation

class DateManager {
    
    static let instance = DateManager()
    
    private let dateFormatter = DateFormatter()
    
    func timeIntervalToHourString(interval : Double) -> String {
        dateFormatter.dateFormat = "HH:00"
        return dateFormatter.string(from: Date(timeIntervalSince1970: interval))
    }
    
    func timeIntervalToHourInt(interval : Double) -> Double {
        dateFormatter.dateFormat = "HH"
        return Double(dateFormatter.string(from: Date(timeIntervalSince1970: interval))) ?? 0.0
    }
    
    func timeIntervalToReadableDayString(interval : Double) -> String {
        let date = Date(timeIntervalSince1970: interval)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
}
