//
//  currentWeatherModel.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/24.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import Foundation

struct CurrentWeather: Decodable {
    let weather: Weather
    
}

struct Weather: Decodable {
    let hourly: [Hourly]
}

struct Hourly: Decodable {
    let grid: Grid
    let sky: Sky
    let temperature: Temperature
}

struct Grid: Decodable {
    let latitude, longitude, city, county: String
    let village: String
}

struct Sky: Decodable {
    let code, name: String
}

struct Temperature: Decodable {
    let tc, tmax, tmin: String
}


//// MARK: - CustomStringConvertible
//
//extension CurrentWeather: CustomStringConvertible {
//  var description: String {
//    return """
//    Grid : \(grid)
//    Wind : \(wind)
//    Precipitation : \(precipitation)
//    Sky : \(sky)
//    Temperature : \(temperature)
//    Humidity : \(humidity)
//    """
//  }
//}


