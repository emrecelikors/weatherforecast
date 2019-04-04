//
//  ForecastViewController.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 4.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    var viewModel = ForecastViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let output = viewModel.transform(input: ForecastViewModel.Input(location: LocationManager.instance.location))
        output.example.asObservable()
            .subscribe(onNext : { value in
                print("blabla")
            })
        
    }
}
