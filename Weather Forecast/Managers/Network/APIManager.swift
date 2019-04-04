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
    
    static func fetchObject<T: Decodable>(endpoint : Endpoint) -> Observable<T> {
        return Observable.create { observer -> Disposable in
            print(endpoint.urlString)
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
                            let friends = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(friends)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = FailureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }
    
}



