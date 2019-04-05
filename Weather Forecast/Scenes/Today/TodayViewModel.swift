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
        let location : ReplaySubject<CLLocation>
        let placemark: ReplaySubject<CLPlacemark>
    }
    
    struct Output {
        let loadingDriver : Driver<Bool>
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
            .takeLast(1)
            .flatMapLatest { (location) -> Observable<WeatherResponse> in
                return APIManager.fetchObject(endpoint: .getTodaysWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)).trackActivity(self.loading)
            }
            .subscribe(onNext : { [weak self] value in
                self?.weatherResponseSubject.onNext(value)
            }).disposed(by: bag)
        
        let countryTextDriver = input.placemark
            .map({
                "\($0.locality ?? ""), \($0.country ?? "")"
            })
            .asDriver(onErrorJustReturn: "Country couldn't found")
        
        let degreeAndSummaryTextDriver = weatherResponseSubject
            .map({ value in
                let weather = value.weather?.first
                return "\(Int(value.main?.temp ?? 0))℃ | \(weather?.description?.capitalized ?? "")"
            })
            .asDriver(onErrorJustReturn: "Error occured.")
        
        let humidityTextDriver = weatherResponseSubject
            .map({ value in
                return "\(Int(value.main?.humidity ?? 0))%"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        let weatherImageNameDriver = weatherResponseSubject
            .map({ value in
                return "\(value.weather?.first?.getWeatherImageName() ?? "")"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        let precipitationTextDriver = weatherResponseSubject
            .map({ value in
                return "\(value.rain?.lastHour ?? value.rain?.lastThreeHours ?? 0) mm"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        let pressureTextDriver = weatherResponseSubject
            .map({ value in
                return "\(Int(value.main?.pressure ?? 0)) hPa"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        let windTextDriver = weatherResponseSubject
            .map({ value in
                return "\(Int(value.wind?.speed ?? 0)) km/h"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        let windDirectionTextDriver = weatherResponseSubject
            .map({ value in
                return "\(value.wind?.deg?.direction.description ?? "")"
            })
            .asDriver(onErrorJustReturn: "n/a")
        
        let loadingDriver = loading.asDriver()
        
        return Output(loadingDriver : loadingDriver
            , weatherImageNameDriver: weatherImageNameDriver
            , countryTextDriver: countryTextDriver
            , degreeAndSummaryTextDriver: degreeAndSummaryTextDriver
            , humidityTextDriver: humidityTextDriver
            , precipitationTextDriver: precipitationTextDriver
            , pressureTextDriver: pressureTextDriver
            , windTextDriver: windTextDriver
            , windDirectionTextDriver: windDirectionTextDriver)
    }
}
