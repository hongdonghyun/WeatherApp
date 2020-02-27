//
//  Constants.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/24.
//  Copyright © 2020 hong3. All rights reserved.
//

import Foundation

struct Constants {
    static let appKey = "l7xx4c4586e71b774a44adad65a13d027aad"
    static let secretKey = "15b9cd048e854c62a6d743daa74eb1f8"
    static let baseUrl = "apis.openapi.sk.com"
    static let localeKo = "ko"
    
    enum EndPoint: String {
        case currentWeatherEndPoint = "/weather/current/hourly"
        case shortTermforecast = "/weather/forecast/3days"
    }
    
    enum RequestMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
}

enum WeatherImages: String {
    case cloudy
    case lightning
    case rainy
    case sunny
}

enum DateType: String {
    case yearDate = "yyyy-MM-dd HH:mm:ss"
    case currentDate = "a h:mm"
    case dayTime = "M.d (E)/HH:mm"
}
