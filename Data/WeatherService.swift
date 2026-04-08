//
//  WeatherService.swift
//  API_Weather
//
//  Created by Hoàng Võ on 20/03/2026.
//

import UIKit

class WeatherService {
    private let apikey = Secrets.openWeatherAPIKey
    
    func fetchWeather (city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedCity.isEmpty else {
            completion(.failure(NSError(domain: "WeatherService", code: 400, userInfo: [
                NSLocalizedDescriptionKey: "City name is empty"
            ])))
            return
        }
        guard var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather") else {
            completion(.failure(NSError(domain: "WeatherService", code: 500, userInfo: [
                NSLocalizedDescriptionKey: "Invalid base URL "
            ])))
            return
        }
        components.queryItems = [
            URLQueryItem(name: "q", value: trimmedCity),
            URLQueryItem(name: "appid", value: apikey),
            URLQueryItem(name: "units", value: "metric")
        ]
        guard let url = components.url else {
            completion(.failure(NSError(domain: "WeatherService", code: 500, userInfo: [
                NSLocalizedDescriptionKey: "Failed to build API"
            ])))
            return
        }
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "WeatherService", code: 500, userInfo: [
                    NSLocalizedDescriptionKey: "Invalid response from server."
                ])))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "WeatherService", code: 500, userInfo: [
                    NSLocalizedDescriptionKey: "No data received"
                ])))
                return
            }
            do {
                if (200...299).contains(httpResponse.statusCode) {
                    let result = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } else {
                    let apiError = try? JSONDecoder().decode(WeatherAPIError.self, from: data)
                    let message = apiError?.message ?? "Failed to fetch weather."
                                
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "WeatherService", code: httpResponse.statusCode, userInfo: [
                            NSLocalizedDescriptionKey: message
                        ])))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
 
