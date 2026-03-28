# WeatherAPIApp

A simple UIKit-based weather application built with Swift. The app fetches real-time weather data from the OpenWeather API and displays basic weather information using a lightweight MVVM structure.

## Features

- Fetch weather data for a city using REST API
- Decode JSON response with `Codable`
- Display city name, temperature, and weather description
- Separate code into Service, Model, ViewModel, and View layers
- Refresh weather data from the UI

## Tech Stack

- Swift
- UIKit
- MVVM (basic)
- URLSession
- Codable / JSONDecoder
- Xcode

## Project Structure

- `WeatherService.swift` – handles API requests
- `WeatherResponse.swift` – weather response models
- `WeatherViewModel.swift` – prepares data for UI
- `WeatherViewController.swift` – displays weather information

## What I Learned

- How to call a REST API in an iOS app using `URLSession`
- How to decode JSON into Swift models with `Codable`
- How to organize a small app using a basic MVVM approach
- How to update UIKit UI from asynchronous network callbacks
- How to apply simple business logic inside a ViewModel

## Future Improvements

- Add search input for dynamic city names
- Improve error handling and loading states
- Hide API key from source code
- Format temperature output more cleanly
- Improve UI design and responsiveness

## How to Run

1. Clone this repository
2. Open the project in Xcode
3. Build and run on iOS Simulator
4. Make sure the API key is valid before running the app

## Screenshot

_Add your app screenshot here_
