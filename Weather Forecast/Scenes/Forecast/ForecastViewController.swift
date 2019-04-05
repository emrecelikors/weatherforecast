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
import RxDataSources

class ForecastViewController: UIViewController {

    var viewModel = ForecastViewModel()
    let dataSource = ForecastViewController.dataSource()
    
    @IBOutlet weak var tableView: UITableView!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        self.configureUI()
    }
    
    private func bindViewModel() {
        
        let locationManager = LocationManager.instance
        let inputs = ForecastViewModel.Input(location: locationManager.location, placemark : locationManager.placemark)
        let outputs = viewModel.transform(input: inputs)
        
        outputs.loadingDriver
            .map({
                return !$0
            })
            .drive(BaseIndicatorView.instance.indicatorView.rx.isHidden)
            .disposed(by: bag)
        
        outputs.countryTextDriver
            .drive(self.navigationItem.rx.title)
            .disposed(by: bag)
        
        outputs.weatherDataSourceDriver
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        tableView
            .rx.setDelegate(self)
            .disposed(by: bag)
    }
    
    private func configureUI() {
        tableView.allowsSelection = false
        tableView.rowHeight = 90.0
    }
    
}

extension ForecastViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, WeatherResponse>> {
        
        return RxTableViewSectionedReloadDataSource<SectionModel<String, WeatherResponse>>(
            configureCell: { (dataSource, table, idxPath, item) in
                guard let cell: ForecastTableViewCell = table.dequeueReusableCell(withIdentifier: ForecastTableViewCell.reuseID, for: idxPath) as? ForecastTableViewCell else {
                    return UITableViewCell()
                }
                cell.bind(item)
                return cell
        })
        
    }
}

extension ForecastViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: ForecastHeaderTableViewCell.reuseID) as? ForecastHeaderTableViewCell else {
            return UIView()
        }
        headerCell.bind(dataSource[section].items.first!)
        return headerCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
}
