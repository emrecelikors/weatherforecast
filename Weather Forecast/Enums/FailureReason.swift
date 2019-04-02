//
//  FailureReason.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 2.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation

enum FailureReason: Int, Error {
    case unAuthorized = 401
    case notFound = 404
}
