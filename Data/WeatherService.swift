//
//  WeatherService.swift
//  API_Weather
//
//  Created by Hoàng Võ on 20/03/2026.
//

import UIKit

class WeatherService {
    func fetchWeather (city: String, completion: @escaping (WeatherResponse?) -> Void) {
        guard let url = Bundle.main.url(forResource: "weathers", withExtension: "json") else {
            print("Không tìm thấy file JSON")
            completion(nil)
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode([WeatherResponse].self, from: data)
            let matchedWeather = result.first {
                $0.name.lowercased() == city.lowercased()
            }
            DispatchQueue.main.async {
                completion(matchedWeather)
            }
        } catch {
            print("Decode lỗi", error)
            completion(nil)
        }
    }
}
