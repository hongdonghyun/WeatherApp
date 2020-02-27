//
//  Constants.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/24.
//  Copyright © 2020 hong3. All rights reserved.
//

import Foundation

struct Constants {
    static let appKey = "앱 키 입력"
    static let secretKey = "시크릿 키"
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
