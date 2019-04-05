//
//  LocationManager.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 2.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa
import RxCoreLocation


class LocationManager {
    
    static let instance = LocationManager()
    private (set) var location = ReplaySubject<CLLocation>.createUnbounded()
    private (set) var placemark = ReplaySubject<CLPlacemark>.createUnbounded()
    private let locationManager = CLLocationManager()
    private let bag = DisposeBag()
    
    private init() {
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        locationManager.rx
            .location
            .take(1)
            .subscribe(onNext: { [weak self] location in
                self?.locationManager.stopUpdatingLocation()
                guard let location = location else { return }
                self?.location.onNext(location)
            })
            .disposed(by: bag)
        
        locationManager.rx
            .placemark
            .subscribe(onNext: { [weak self] placemark in
                self?.placemark.onNext(placemark)
            })
            .disposed(by: bag)
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
