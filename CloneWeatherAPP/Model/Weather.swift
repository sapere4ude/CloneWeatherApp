//
//  Weather.swift
//  CloneWeatherAPP
//
//  Created by sapere4ude on 2020/11/16.
//

import Foundation

// MARK: WeatherInfo
struct WeatherInfo: Codable {
    let coord: Coord
    let weather: [Weather] // 정보가 딕셔너리 형태로 들어있다
    let base: String
    let main: Main
    let visibility: Int?
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

// MARK: Coord
struct Coord: Codable {
    let lon: Double
    let lat: Double
    
}

// MARK: Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: Main
struct Main: Codable {
    let temp: Double
    let humidity: Int
    let tempMin: Double
    let tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: Wind
struct Wind: Codable {
    let speed: Double
    let deg: Double // 나중에 ? 가 왜 있어야하는건지 체크해보기
    
}
struct Clouds: Codable {
    let all: Int
    
}

// MARK: Sys
struct Sys: Codable {
    let type: Int   // 나중에 ? 가 왜 있어야하는건지 체크해보기
    let id: Int     // 나중에 ? 가 왜 있어야하는건지 체크해보기
    let message: Double
    let country: String
    let sunrise: Int
    let sunset: Int
    
}



