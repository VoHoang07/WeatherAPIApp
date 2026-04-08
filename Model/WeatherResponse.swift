//
//  WeatherResponse.swift
//  API_Weather
//
//  Created by Hoàng Võ on 20/03/2026.
//

import UIKit

struct WeatherResponse: Codable {
    let name: String
    let main: MainInfo
    let weather: [WeatherInfo]
}

struct MainInfo: Codable {
    let temp: Double
    let humidity: Int
}

struct WeatherInfo: Codable {
    let main: String
    let description: String
}
