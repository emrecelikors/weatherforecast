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
    
    private let bag = DisposeBag()
    
    struct Input {
        let location : Observable<CLLocation>
        let placemark: Observable<[CLPlacemark]>
    }
    
    struct Output {
        let countryTextDriver : Driver<String>
        let degreeAndSummaryTextDriver : Driver<String>
        let humidityTextDriver : Driver<String>
        let precipitationTextDriver : Driver<String>
        let pressureTextDriver : Driver<String>
        let windTextDriver : Driver<String>
        let windDirectionTextDriver : Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let weather = input.location
            .takeLast(1)
            .flatMapLatest { (location) -> Observable<WeatherResponse> in
                return APIManager.fetchObject(endpoint: .getTodaysWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude))
            }
        
        let countryTextDriver = input.placemark
            .takeLast(1)
            .map({
                "\($0.first?.locality ?? ""), \($0.first?.country ?? "")"
                
            })
            .asDriver(onErrorJustReturn: "Country couldn't found")
        
        let degreeAndSummaryTextDriver = weather
            .asObservable()
            .trackActivity(loading)
            .map({ value in
                let weather = value.weather.first
                return "\(Int(value.main.temp))℃ | \(weather?.main ?? "")"
            })
            .asDriver(onErrorJustReturn: "Error occured.")
        
        let humidityTextDriver = weather
            .map({ value in
                return "\(Int(value.main.humidity))%"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        let precipitationTextDriver = weather
            .map({ value in
                return "\(value.rain?.lastHour ?? value.rain?.lastThreeHours ?? 0) mm"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        let pressureTextDriver = weather
            .map({ value in
                return "\(value.main.pressure) hPa"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        let windTextDriver = weather
            .map({ value in
                return "\(Int(value.wind.speed)) km/h"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        let windDirectionTextDriver = weather
            .map({ value in
                return "\(value.wind.deg.direction.description)"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        
        loading.asObservable().subscribe(onNext : {
            value in print("")
        }).disposed(by: bag)
        
        return Output(countryTextDriver: countryTextDriver
            , degreeAndSummaryTextDriver: degreeAndSummaryTextDriver
            , humidityTextDriver: humidityTextDriver
            , precipitationTextDriver: precipitationTextDriver
            , pressureTextDriver: pressureTextDriver
            , windTextDriver: windTextDriver
            , windDirectionTextDriver: windDirectionTextDriver)
    }
}
