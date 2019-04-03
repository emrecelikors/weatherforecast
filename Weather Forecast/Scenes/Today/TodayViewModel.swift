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

class TodayViewModel : BaseViewModel, ViewModelType {
    
    private let bag = DisposeBag()
    
    struct Input {
        
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
        
        let locationManager = LocationManager.instance
        //Fetches object after reaching coordinates
        let weather = locationManager.location
            .takeLast(1)
            .flatMapLatest { (location) -> Observable<WeatherResponse> in
                return APIManager.fetchObject(endpoint: .getTodaysWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude))
            }
        
        let countryTextDriver = locationManager.placemark
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
            .asDriver(onErrorJustReturn: "Error occured.")
        
        let precipitationTextDriver = weather
            .map({ value in
                return "1.00 mm"
            })
            .asDriver(onErrorJustReturn: "Error occured.")
        
        let pressureTextDriver = weather
            .map({ value in
                return "\(value.main.pressure)"
            })
            .asDriver(onErrorJustReturn: "Error occured.")
        
        let windTextDriver = weather
            .map({ value in
                return "\(Int(value.wind.speed)) km/h"
            })
            .asDriver(onErrorJustReturn: "Error occured.")
        
        let windDirectionTextDriver = weather
            .map({ value in
                return "\(value.wind.deg)"
            })
            .asDriver(onErrorJustReturn: "Error occured.")
        
        
        loading.asObservable().subscribe(onNext : {
            value in print(value.description)
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
