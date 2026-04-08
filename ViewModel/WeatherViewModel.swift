//
//  WeatherViewModel.swift
//  API_Weather
//
//  Created by Hoàng Võ on 20/03/2026.
//

import UIKit

enum WeatherViewState {
    case idle
    case loading
    case success(WeatherResponse)
    case error(String)
}
final class WeatherViewModel {
    //MARK: - ViewState
    private let recentSearchesKey = "recent_searches"
    
    var onStateWeather: ((WeatherViewState) -> Void)?
    //MARK: - Properties (data for UI)
    var cityName: String = ""
    var temperature: String = ""
    var weatherDescription: String = ""
    
    //MARK: - Service
    private let service = WeatherService()
    
    //MARK: - fetch API
    func fetchWeather(city: String, completion: ((WeatherResponse?) -> Void)? = nil) {
        onStateWeather?(.loading)
        
        service.fetchWeather(city: city) {[weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let data):
                self.saveRecentSearches(city: city)
                self.onStateWeather?(.success(data))
                completion?(data)
                            
            case .failure(let error):
                self.onStateWeather?(.error(error.localizedDescription))
                completion?(nil)
            }
//            //MARK: - business logic
////            let celsius = data.main.temp - 273.15
//            self.cityName = data.name
//            self.temperature = /*String(format: "%.1f°C", celsius)*/"\(data.main.temp)"
//            self.weatherDescription = data.weather.first?.description ?? ""
//            
//            // Báo cho View updata UI
//            completion(response)
        }
    }
    func getRecentSearches() -> [String] {
        UserDefaults.standard.stringArray(forKey: recentSearchesKey) ?? []
    }
    private func saveRecentSearches(city: String) {
        let nomalizedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !nomalizedCity.isEmpty else {return}
        
        var searches = getRecentSearches()
        
        searches.removeAll {$0.lowercased() == nomalizedCity.lowercased()}
        searches.insert(nomalizedCity, at: 0)
        
        if searches.count > 5 {
            searches = Array(searches.prefix(5))
        }
        UserDefaults.standard.set(searches, forKey: recentSearchesKey)
    }

}
