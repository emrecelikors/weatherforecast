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
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        
    }
    
    private func bindViewModel() {
        let inputs = TodayViewModel.Input()
        let outputs = viewModel.transform(input: inputs)
        
    }
}
