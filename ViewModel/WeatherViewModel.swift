//
//  WeatherViewModel.swift
//  API_Weather
//
//  Created by Hoàng Võ on 20/03/2026.
//

import UIKit

class WeatherViewModel {
    //MARK: - Properties (data for UI)
    var cityName: String = ""
    var temprature: String = ""
    var description: String = ""
    
    //MARK: - Service
    private let service = WeatherService()
    
    //MARK: - fetch API
    func fetchWeather(completion: @escaping() -> Void) {
        service.fetchWeather(city: "Saigon") { [weak self] response in
            guard let self = self,
                  let data = response else {return}
            //MARK: - business logic
            let celsius = data.main.temp - 273.15
            self.cityName = data.name
            self.temprature = "\(celsius)°C"
            self.description = data.weather.first?.description ?? ""
            
            // Báo cho View updata UI
            completion()
        }
    }
}
