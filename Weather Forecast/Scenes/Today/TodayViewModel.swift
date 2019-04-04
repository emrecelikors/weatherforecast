//
//  TodayViewModel.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 2.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class TodayViewModel : BaseViewModel, ViewModelType {
    
    var weatherResponseSubject = PublishSubject<WeatherResponse>()
    
    struct Input {
        let location : PublishSubject<CLLocation>
        let placemark: PublishSubject<CLPlacemark>
    }
    
    struct Output {
        let weatherImageNameDriver : Driver<String>
        let countryTextDriver : Driver<String>
        let degreeAndSummaryTextDriver : Driver<String>
        let humidityTextDriver : Driver<String>
        let precipitationTextDriver : Driver<String>
        let pressureTextDriver : Driver<String>
        let windTextDriver : Driver<String>
        let windDirectionTextDriver : Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        input.location
            .flatMapLatest { (location) -> Observable<WeatherResponse> in
                return APIManager.fetchObject(endpoint: .getTodaysWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude))
            }.subscribe(onNext : { [weak self] value in
                self?.weatherResponseSubject.onNext(value)
            }).disposed(by: bag)
        
        let countryTextDriver = input.placemark
            .map({
                "\($0.locality ?? ""), \($0.country ?? "")"
            })
            .asDriver(onErrorJustReturn: "Country couldn't found")
        
        let degreeAndSummaryTextDriver = weatherResponseSubject
            .trackActivity(loading)
            .map({ value in
                let weather = value.weather.first
                return "\(Int(value.main.temp))℃ | \(weather?.main ?? "")"
            })
            .asDriver(onErrorJustReturn: "Error occured.")
        
        let humidityTextDriver = weatherResponseSubject
            .map({ value in
                return "\(Int(value.main.humidity))%"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        let weatherImageNameDriver = weatherResponseSubject
            .map({ value in
                return "\(value.weather.first?.getWeatherImageName(dayTime: DayTime()) ?? "")"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        let precipitationTextDriver = weatherResponseSubject
            .map({ value in
                return "\(value.rain?.lastHour ?? value.rain?.lastThreeHours ?? 0) mm"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        let pressureTextDriver = weatherResponseSubject
            .map({ value in
                return "\(value.main.pressure) hPa"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        let windTextDriver = weatherResponseSubject
            .map({ value in
                return "\(Int(value.wind.speed)) km/h"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        let windDirectionTextDriver = weatherResponseSubject
            .map({ value in
                return "\(value.wind.deg.direction.description)"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        
        loading.asObservable().subscribe(onNext : {
            value in print("")
        }).disposed(by: bag)
        
        return Output(weatherImageNameDriver: weatherImageNameDriver
            , countryTextDriver: countryTextDriver
            , degreeAndSummaryTextDriver: degreeAndSummaryTextDriver
            , humidityTextDriver: humidityTextDriver
            , precipitationTextDriver: precipitationTextDriver
            , pressureTextDriver: pressureTextDriver
            , windTextDriver: windTextDriver
            , windDirectionTextDriver: windDirectionTextDriver)
    }
}
