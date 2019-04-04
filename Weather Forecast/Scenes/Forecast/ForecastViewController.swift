//
//  ForecastViewController.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 4.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ForecastViewController: UIViewController {

    var viewModel = ForecastViewModel()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        let locationManager = LocationManager.instance
        let inputs = ForecastViewModel.Input(location: locationManager.location, placemark : locationManager.placemark)
        let outputs = viewModel.transform(input: inputs)
        
        outputs.countryTextDriver
            .drive(self.navigationItem.rx.title)
            .disposed(by: bag)
        
    }
}
