//
//  TodayViewController.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 2.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TodayViewController : UIViewController {
    
    var viewModel = TodayViewModel()
    
    @IBOutlet weak var degreeAndSummaryLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var mainWeatherImageView: UIImageView!
    @IBOutlet weak var upperView: UIView!
    
    var shareText = "Share Description"
    
    private let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        self.configureUI()
    }
    
    private func configureUI() {
        self.title = "Today"
    }
    
    @IBAction func shareAction() {
        let image = self.upperView.takeScreenshot()
        guard let countryText = countryLabel.text else {
            return
        }
        let shareText = "Hey, check out weather of \(countryText)" as AnyObject
        let activityItem: [AnyObject] = [image, shareText]
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        self.present(avc, animated: true, completion: nil)
    }
    
    private func bindViewModel() {
        
        let locationManager = LocationManager.instance
        let inputs = TodayViewModel.Input(location: locationManager.location, placemark : locationManager.placemark)
        let outputs = viewModel.transform(input: inputs)
        
        outputs.loadingDriver
            .map({
                return !$0
            })
            .drive(BaseIndicatorView.instance.indicatorView.rx.isHidden)
            .disposed(by: bag)
        
        outputs.weatherImageNameDriver
            .map({
                UIImage(named: $0)
            }).drive(mainWeatherImageView.rx.image)
            .disposed(by: bag)
        
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
