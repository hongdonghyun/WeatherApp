//
//  DecodableExtension.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/27.
//  Copyright © 2020 hong3. All rights reserved.
//

import Foundation

// Json Decodable Extension
// JsonDecoder().decode(Type.self ,data)
extension Decodable {
    static func decode(from data: Data, decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        return try decoder.decode(self, from: data)
    }
}
