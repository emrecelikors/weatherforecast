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
    
    //For deciding is it gonna be day time or night time image
    init(with hour : Int = Calendar.current.component(.hour, from: Date())) {
        if hour > 6 && hour < 18 {
            self = .Day
        } else {
            self = .Night
        }
    }
    
    
}
