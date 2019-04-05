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
    private (set) var authorized = PublishSubject<Bool>()
    private let locationManager = CLLocationManager()
    private let bag = DisposeBag()
    
    private init() {
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        
        
        locationManager.rx
            .didChangeAuthorization
            .subscribe(onNext: { [weak self] _, status in
                switch status {
                case .denied, .notDetermined, .restricted:
                    self?.authorized.onNext(false)
                case .authorizedAlways, .authorizedWhenInUse:
                    self?.authorized.onNext(true)
                    self?.authorized.onCompleted()
                }
            })
            .disposed(by: bag)
        
        locationManager.rx
            .location
            .subscribe(onNext: { [weak self] location in
                self?.locationManager.stopUpdatingLocation()
                guard let location = location else { return }
                self?.location.onNext(location)
                self?.location.onCompleted()
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
