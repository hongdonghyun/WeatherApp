//
//  helpers.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/26.
//  Copyright © 2020 hong3. All rights reserved.
//

import Foundation

func strDateAddingInterval(dateString: String, interval: Int) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = DateType.yearDate.rawValue
    let strToDate = dateFormatter.date(from: dateString)!
    let addIntervalDate = strToDate.addingTimeInterval(TimeInterval(3600 * interval))
    dateFormatter.dateFormat = DateType.dayTime.rawValue
    dateFormatter.locale = Locale(identifier: Constants.localeKo)
    
    return dateFormatter.string(from: addIntervalDate)
}

func stringDoubleRounded(string: String, rounded: Int) -> String {
    guard let DString = Double(string) else { return "" }
    return String(format: "%.\(rounded)f", DString)
}

