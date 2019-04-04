//
//  ForecastViewModel.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 4.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class ForecastViewModel : BaseViewModel, ViewModelType {
    struct Input {
        let location : Observable<CLLocation>
    }
    struct Output {
        let example : Driver<String>
    }
    func transform(input: Input) -> Output {
        
        let forecastList = input.location
            .take(1)
            .flatMapLatest { (location) -> Observable<WeatherResponse> in
                return APIManager.fetchObject(endpoint: .getForecast(lat: location.coordinate.latitude, lon: location.coordinate.longitude))
        }
        
        let degreeAndSummaryTextDriver = forecastList
            .asObservable()
            .map({ value in
                let weather = value
                return weather.name
            })
            .asDriver(onErrorJustReturn: "Error occured.")
        
        return Output(example: degreeAndSummaryTextDriver)
    }
}
