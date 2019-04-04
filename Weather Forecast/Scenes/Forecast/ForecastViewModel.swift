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
    
    var forecastResponseSubject = PublishSubject<ForecastResponse>()
    
    struct Input {
        let location : ReplaySubject<CLLocation>
        let placemark: ReplaySubject<CLPlacemark>
    }
    struct Output {
        let countryTextDriver : Driver<String>
        let weatherListDriver : Driver<[WeatherResponse]>
    }
    
    func transform(input: Input) -> Output {
        
        input.location
            .flatMapLatest { (location) -> Observable<ForecastResponse> in
                return APIManager.fetchObject(endpoint: .getForecast(lat: location.coordinate.latitude, lon: location.coordinate.longitude))
            }.subscribe(onNext : { [weak self] value in
                self?.forecastResponseSubject.onNext(value)
            }).disposed(by: bag)
        
        let countryTextDriver = input.placemark
            .map({
                "\($0.locality ?? "")"
            })
            .asDriver(onErrorJustReturn: "No Country Boy")
        
        let weatherListDriver = forecastResponseSubject.trackActivity(loading)
            .map({ value in
                return value.list
            })
            .asDriver(onErrorJustReturn: [])
        
        
        return Output(countryTextDriver: countryTextDriver, weatherListDriver: weatherListDriver)
    }
}
