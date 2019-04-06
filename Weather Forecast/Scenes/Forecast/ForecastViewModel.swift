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
import RxDataSources
import CoreLocation

class ForecastViewModel : BaseViewModel, ViewModelType {
    
    private var forecastResponseSubject = PublishSubject<ForecastResponse>()
    
    struct Input {
        let location : ReplaySubject<CLLocation>
        let placemark: ReplaySubject<CLPlacemark>
    }
    struct Output {
        let loadingDriver : Driver<Bool>
        let countryTextDriver : Driver<String>
        let weatherDataSourceDriver : Driver<[SectionModel<String, WeatherResponse>]>
    }
    
    func transform(input: Input) -> Output {
        
        input.location
            .flatMapLatest { (location) -> Observable<ForecastResponse> in
                return APIManager.instance.fetchObject(endpoint: .getForecast(lat: location.coordinate.latitude, lon: location.coordinate.longitude)).trackActivity(self.loading)
            }.subscribe(onNext : { [weak self] value in
                self?.forecastResponseSubject.onNext(value)
            }).disposed(by: bag)
        
        let countryTextDriver = input.placemark
            .map({
                "\($0.locality ?? "")"
            })
            .asDriver(onErrorJustReturn: "No Country Boy")
        
        
        let weatherDataSourceDriver = forecastResponseSubject
            .map({ value  -> ([SectionModel<String, WeatherResponse>]) in
                
                let array = Dictionary(grouping: value.list, by: {value in
                    value.dayString
                }).map({
                    return SectionModel(model: $0.key, items: $0.value)
                }).sorted(by: { (sectionModel1, sectionModel2) -> Bool in
                    return (sectionModel1.items.first?.dt ?? 0.0 < sectionModel2.items.first?.dt ?? 0.0)
                })
                
                return array
            }).asDriver(onErrorJustReturn: [])
        
        let loadingDriver = loading.asDriver()
        
        return Output(loadingDriver : loadingDriver
            , countryTextDriver: countryTextDriver
            , weatherDataSourceDriver: weatherDataSourceDriver)
    }
}
