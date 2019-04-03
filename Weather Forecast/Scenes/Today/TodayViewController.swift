//
//  TodayViewController.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 2.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation
import RxSwift

class TodayViewController : UIViewController {
    
    var viewModel = TodayViewModel()
    
    @IBOutlet weak var degreeAndSummaryLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    
    
    private let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        self.configureUI()
    }
    
    private func configureUI() {
        self.title = "Today"
    }
    
    
    private func bindViewModel() {
        
        let locationManager = LocationManager.instance
        let inputs = TodayViewModel.Input(location: locationManager.location, placemark : locationManager.placemark)
        let outputs = viewModel.transform(input: inputs)
        
        outputs.degreeAndSummaryTextDriver
            .drive(degreeAndSummaryLabel.rx.text)
            .disposed(by: bag)
        
        outputs.countryTextDriver
            .drive(countryLabel.rx.text)
            .disposed(by: bag)
        
        outputs.humidityTextDriver
            .drive(humidityLabel.rx.text)
            .disposed(by: bag)
        
        outputs.precipitationTextDriver
            .drive(precipitationLabel.rx.text)
            .disposed(by: bag)
        
        outputs.pressureTextDriver
            .drive(pressureLabel.rx.text)
            .disposed(by: bag)
        
        outputs.windTextDriver
            .drive(windLabel.rx.text)
            .disposed(by: bag)
        
        outputs.windDirectionTextDriver
            .drive(windDirectionLabel.rx.text)
            .disposed(by: bag)
        
    }
}
