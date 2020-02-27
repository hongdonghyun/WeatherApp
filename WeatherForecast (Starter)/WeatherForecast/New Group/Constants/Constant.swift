//
//  Constants.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/24.
//  Copyright © 2020 Giftbot. All rights reserved.
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



let dumpData = """
{
    "weather": {
        "forecast3days": [
            {
                "timeRelease": "2020-02-26 14:00:00",
                "fcst3hour": {
                    "sky": {
                        "code4hour": "SKY_S03",
                        "name4hour": "구름많음",
                        "code7hour": "SKY_S07",
                        "name7hour": "흐림",
                        "code10hour": "SKY_S03",
                        "name10hour": "구름많음",
                        "code13hour": "SKY_S01",
                        "name13hour": "맑음",
                        "code16hour": "SKY_S01",
                        "name16hour": "맑음",
                        "code19hour": "SKY_S01",
                        "name19hour": "맑음",
                        "code22hour": "SKY_S01",
                        "name22hour": "맑음",
                        "code25hour": "SKY_S01",
                        "name25hour": "맑음",
                        "code28hour": "SKY_S01",
                        "name28hour": "맑음",
                        "code31hour": "SKY_S01",
                        "name31hour": "맑음",
                        "code34hour": "SKY_S03",
                        "name34hour": "구름많음",
                        "code37hour": "SKY_S03",
                        "name37hour": "구름많음",
                        "code40hour": "SKY_S07",
                        "name40hour": "흐림",
                        "code43hour": "SKY_S07",
                        "name43hour": "흐림",
                        "code46hour": "SKY_S08",
                        "name46hour": "흐리고 비",
                        "code49hour": "SKY_S08",
                        "name49hour": "흐리고 비",
                        "code52hour": "SKY_S08",
                        "name52hour": "흐리고 비",
                        "code55hour": "SKY_S08",
                        "name55hour": "흐리고 비",
                        "code58hour": "SKY_S07",
                        "name58hour": "흐림",
                        "code61hour": "",
                        "name61hour": "",
                        "code64hour": "",
                        "name64hour": "",
                        "code67hour": "",
                        "name67hour": ""
                    },
                    "temperature": {
                        "temp4hour": "8.00",
                        "temp7hour": "6.00",
                        "temp10hour": "5.00",
                        "temp13hour": "4.00",
                        "temp16hour": "3.00",
                        "temp19hour": "4.00",
                        "temp22hour": "8.00",
                        "temp25hour": "10.00",
                        "temp28hour": "9.00",
                        "temp31hour": "6.00",
                        "temp34hour": "5.00",
                        "temp37hour": "4.00",
                        "temp40hour": "4.00",
                        "temp43hour": "4.00",
                        "temp46hour": "6.00",
                        "temp49hour": "5.00",
                        "temp52hour": "6.00",
                        "temp55hour": "5.00",
                        "temp58hour": "6.00",
                        "temp61hour": "",
                        "temp64hour": "",
                        "temp67hour": ""
                    }
                }
            }
        ]
    }
}
""".data(using: .utf8)!
