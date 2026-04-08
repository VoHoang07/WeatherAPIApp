//
//  WeatherAPIError.swift
//  API_Weather
//
//  Created by Hoàng Võ on 08/04/2026.
//

import Foundation

struct WeatherAPIError: Codable {
    let cod: String?
    let message: String?
}
