//
//  Models.swift
//  luchit22weatherApp
//
//  Created by lukss on 30.01.26.
//

import Foundation

struct WeatherResponse: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let clouds: Clouds
}

struct ForecastResponse: Codable {
    let city: City
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let clouds: Clouds
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Clouds: Codable {
    let all: Int
}

struct City: Codable {
    let name: String
}


