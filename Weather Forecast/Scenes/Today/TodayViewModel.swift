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
    
    private var weather : Observable<WeatherResponse>?
    private let locationManager = LocationManager.instance
    
    private let bag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let mainTextDriver : Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        //Fetches object after reaching coordinates
        weather = locationManager.location
            .takeLast(1)
            .flatMapLatest { (location) -> Observable<WeatherResponse> in
                return APIManager.fetchObject(endpoint: .getTodaysWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude))
            }
        
        
        let mainTextDriver = weather?
            .asObservable()
            .trackActivity(loading)
            .map({ value in
                return value.weather.first?.description ?? "No Description"
            })
            .startWith("")
            .asDriver(onErrorJustReturn: "Error occured.")
        
        return Output(mainTextDriver: mainTextDriver!)
    }
}
