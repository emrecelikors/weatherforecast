//
//  ForecastViewModelTests.swift
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

class ForecastViewModelTests: QuickSpec {
    
    override func spec() {
        var disposeBag: DisposeBag!
        var viewModelOutput: ForecastViewModel.Output!
        beforeEach {
            disposeBag = DisposeBag()
        }
        afterEach {
            viewModelOutput = nil // Force viewModel to deallocate and stop syncing.
        }
        
        
        
        describe("Forecast Weather from API with coordinates shows") {
            it("London") {
                viewModelOutput = self.createViewModelOutputFromCoord(coord: Coord(lat: 51.51, lon: -0.13))
                waitUntil(timeout: 15.0) { done in
                    viewModelOutput.weatherDataSourceDriver
                        .asObservable()
                        .subscribe(onNext: { value in
                            expect(value.first?.identity).to(contain("Today"))
                            done()
                        }).disposed(by: disposeBag)
                }
            }
        }
        
        
        
    }
    
    func createViewModelOutputFromCoord(coord : Coord) -> ForecastViewModel.Output {
        let viewModel = ForecastViewModel()
        let locationSubject = ReplaySubject<CLLocation>.createUnbounded()
        let placemarkSubject = ReplaySubject<CLPlacemark>.createUnbounded()
        
        let location = CLLocation(latitude: coord.lat!, longitude: coord.lon!)
        locationSubject.onNext(location)
        locationSubject.onCompleted()
        CLGeocoder.init().reverseGeocodeLocation(location) { (places, error) in
            placemarkSubject.onNext((places?.first)!)
        }
        
        let inputs = ForecastViewModel.Input(location: locationSubject, placemark : placemarkSubject)
        let outputs = viewModel.transform(input: inputs)
        return outputs
    }
    
}
