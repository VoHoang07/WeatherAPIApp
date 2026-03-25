//
//  WeatherService.swift
//  API_Weather
//
//  Created by Hoàng Võ on 20/03/2026.
//

import UIKit

class WeatherService {
    func fetchWeather (city: String, completion: @escaping (WeatherResponse?) -> Void) {
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city

        guard let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?q=\(cityEncoded)&appid=a329559d507506de4666e8a6a8e69128") else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            let result = try? JSONDecoder().decode(WeatherResponse.self, from: data)
            DispatchQueue.main.async {
                completion(result)
            }
        }.resume()
        
    }
}
