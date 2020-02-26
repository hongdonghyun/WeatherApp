//
//  helpers.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/26.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import Foundation

func strDateAddingInterval(dateString: String, interval: Int) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let strToDate = dateFormatter.date(from: dateString)!
    let addIntervalDate = strToDate.addingTimeInterval(TimeInterval(60 * 60 * interval))
    dateFormatter.dateFormat = "M.d (E)/HH:mm"
    dateFormatter.locale = Locale(identifier: "ko")
    
    
    return dateFormatter.string(from: addIntervalDate)
}

func stringDoubleRounded(string: String, indexing: Int) -> String {
    return String(format: "%.\(indexing)f", Double(string)!)
}
