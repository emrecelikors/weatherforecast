//
//  BaseViewModel.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 2.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel : NSObject {
    
    internal let bag = DisposeBag()
    let loading = ActivityIndicator()
    
}
