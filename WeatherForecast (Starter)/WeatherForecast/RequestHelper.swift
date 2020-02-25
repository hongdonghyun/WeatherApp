//
//  RequestHelper.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/24.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import Foundation
import CoreLocation

class RequestHelper {
    static let shared = RequestHelper()
    private var currentParam: [String: String] = [:]
    
    func request(method: Constants.RequestMethod, endPoint: Constants.endPoint, completion: @escaping (Data) -> ()) {
        guard let url = makeUrl(endPoint: endPoint) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) {
            data, res, err in
            if let res = res as? HTTPURLResponse {
                if self.statusValid(statusCode: res.statusCode) {
                    guard let data = data else { return }
                    completion(data)
                } else { print("Server Error") }
            }
        }
        task.resume()
    }
    
    func makeParam(location: CLLocation?)  {
        guard let lat = location?.coordinate.latitude else { return }
        guard let lon = location?.coordinate.longitude else { return }
        currentParam = ["appKey": Constants.appKey, "lat": "\(lat)", "lon": "\(abs(lon))"]
    }
    
    private func statusValid(statusCode: Int) -> Bool { (200..<300).contains(statusCode) }
    
    private func makeUrl(endPoint: Constants.endPoint) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.baseUrl
        components.path = endPoint.rawValue
        
        components.queryItems = currentParam.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        return components.url
    
        
    }
    
    private init() {}
    
}
