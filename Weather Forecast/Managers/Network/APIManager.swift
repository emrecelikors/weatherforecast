//
//  APIManager.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 2.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

final class APIManager {
    
    static let instance = APIManager()
    
    func fetchObject<T: Decodable>(endpoint : Endpoint) -> Observable<T> {
        return Observable.create { observer -> Disposable in
            Alamofire.request(endpoint.urlString)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? FailureReason.notFound)
                            return
                        }
                        do {
                            let result = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(result)
                            observer.onCompleted()
                            self.saveDataToRealm(data: data, endpoint: endpoint)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        //It gets offline data and it shows error
                        if let offlineData = OfflineData.getOfflineData(primaryKey: endpoint.path) {
                            do {
                                let result = try JSONDecoder().decode(T.self, from: offlineData.lastSucceedData)
                                observer.onNext(result)
                            } catch {
                                
                            }
                        }
                        observer.onError(error)
                        
                    }
            }
            
            return Disposables.create()
        }
    }
    
    private func saveDataToRealm(data : Data, endpoint : Endpoint) {
        let offlineData = OfflineData()
        let _ = RealmManager.instance.defaultRealm
        offlineData.screenKey = endpoint.path
        offlineData.lastSucceedData = data
        try! offlineData.save()
    }
    
}



