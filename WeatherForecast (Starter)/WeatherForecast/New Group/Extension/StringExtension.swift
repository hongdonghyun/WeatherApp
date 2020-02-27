//
//  StringExtension.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/27.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import Foundation

extension String {
    func getStrInInt() -> Int {
        Int(self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? 0
    }
}
