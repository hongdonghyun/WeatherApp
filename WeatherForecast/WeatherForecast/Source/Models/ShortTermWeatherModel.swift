//
//  ShortTermWeatherModel.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/26.
//  Copyright © 2020 hong3. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ShortTermWeatherModel: Decodable {
    let weather: ShortTermWeather
}

// MARK: - Weather
struct ShortTermWeather: Decodable {
    let forecast3Days: [Forecast3Day]
    
    enum CodingKeys: String, CodingKey {
        case forecast3Days = "forecast3days"
    }
}

// MARK: - Forecast3Day
struct Forecast3Day: Decodable {
    let timeRelease: String
    let fcst3Hour: Fcst3Hour
    
    enum CodingKeys: String, CodingKey {
        case timeRelease
        case fcst3Hour = "fcst3hour"
    }
}

// MARK: - Fcst3Hour
struct Fcst3Hour: Decodable {
    let sky: [String: String]
    let temperature: [String: String]
}

