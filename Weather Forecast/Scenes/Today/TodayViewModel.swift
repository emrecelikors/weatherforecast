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
    
    struct Input {
        
    }
    
    struct Output {
        let mainTextDriver : Driver<String>
    }
    
    func transform(input: Input) -> Output {
        weather = APIManager.fetchObject(endpoint: .getTodaysWeather(lat: 4.904202, lon: 52.354685))
        
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
