//
//  TodayViewModelTest.swift
//  Weather ForecastTests
//
//  Created by Emre Çelikörs on 6.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import CoreLocation

@testable import Weather_Forecast

class TodayViewModelTests: QuickSpec {
    
    override func spec() {
        var disposeBag: DisposeBag!
        var viewModelOutput: TodayViewModel.Output!
        beforeEach {
            disposeBag = DisposeBag()
        }
        afterEach {
            viewModelOutput = nil // Force viewModel to deallocate and stop syncing.
        }
       
        
        
        describe("Today Weather from API with coordinates shows") {
            it("London") {
                viewModelOutput = self.createViewModelOutputFromCoord(coord: Coord(lat: 51.51, lon: -0.13))
                waitUntil(timeout: 15.0) { done in
                    viewModelOutput.countryTextDriver
                        .asObservable()
                        .subscribe(onNext : { value in
                            expect(value).to(contain("London"))
                            done()
                        }).disposed(by: disposeBag)
                    
                    //Other drivers tests can be added but before that you should know the instant value
                }
            }
        }
        
        
        
    }
    
    func createViewModelOutputFromCoord(coord : Coord) -> TodayViewModel.Output {
        let viewModel = TodayViewModel()
        let locationSubject = ReplaySubject<CLLocation>.createUnbounded()
        let placemarkSubject = ReplaySubject<CLPlacemark>.createUnbounded()
        
        let location = CLLocation(latitude: coord.lat!, longitude: coord.lon!)
        locationSubject.onNext(location)
        locationSubject.onCompleted()
        CLGeocoder.init().reverseGeocodeLocation(location) { (places, error) in
            placemarkSubject.onNext((places?.first)!)
        }
        
        let inputs = TodayViewModel.Input(location: locationSubject, placemark : placemarkSubject)
        let outputs = viewModel.transform(input: inputs)
        
        
        
        
        
        
        
        return outputs
    }
    
}
