//
//  WindDirection.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 3.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation

enum Direction: String {
    case N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW
}

extension Direction: CustomStringConvertible  {
    static let all: [Direction] = [.N, .NNE, .NE, .ENE, .E, .ESE, .SE, .SSE, .S, .SSW, .SW, .WSW, .W, .WNW, .NW, .NNW]
    init(_ direction: Double) {
        let index = Int((direction + 11.25).truncatingRemainder(dividingBy: 360) / 22.5)
        self = Direction.all[index]
    }
    var description: String {
        return rawValue.uppercased()
    }
}

extension Double {
    var direction: Direction {
        return Direction(self)
    }
}
