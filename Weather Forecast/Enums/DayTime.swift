//
//  DayTime.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 3.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation

enum DayTime : String{
    case Day
    case Night
}

extension DayTime {
    
    init() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour > 6 && hour < 18 {
            self = .Day
        } else {
            self = .Night
        }
    }
    
}
