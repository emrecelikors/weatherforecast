//
//  CurrentWeatherSpecs.swift
//  Weather ForecastTests
//
//  Created by Emre Çelikörs on 6.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Quick
import Nimble
@testable import Weather_Forecast

class CurrentWeatherSpecs: QuickSpec {
    
    override func spec() {
        var sut: WeatherResponse!
        
        describe("The 'Current Weather'") {
            context("Can be created with valid JSON") {
                afterEach {
                    sut = nil
                }
                beforeEach {
                    if let path = Bundle(for: type(of: self)
                        ).path(forResource:"london_weather_correct",
                               ofType: "json") {
                        do {
                            let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                                options: .alwaysMapped)
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            sut = try decoder.decode(WeatherResponse.self, from: data)
                        } catch {
                            fail("Problem parsing JSON")
                        }
                    }
                }
                
                it("can parse the correct lat") {
                    expect(sut.coord?.lat).to(equal(51.51))
                }
                
                it("can parse the correct name") {
                    expect(sut.name).to(equal("London"))
                }
                
                it("can parse the correct weather detail") {
                    expect(sut.weather?.first?.main).to(equal("Drizzle"))
                }
                
            }
        }
    }
}
