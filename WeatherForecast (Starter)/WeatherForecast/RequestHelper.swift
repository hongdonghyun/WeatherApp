//
//  RequestHelper.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/24.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import Foundation


class RequestHelper {
    static let shared = RequestHelper()
    private var currentParam: [String: String]?
    
    func request(method: Constants.RequestMethod, endPoint: Constants.endPoint, completion: @escaping (Data) -> ()) {
        guard let url = makeUrl(endPoint: endPoint) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) {
            data, res, err in
            if let res = res as? HTTPURLResponse {
                if self.statusValid(statusCode: res.statusCode) {
                    if let data = data {
                        completion(data)
                    }
                    
                }
            }
        }
        task.resume()
    }
    
    func makeParam(lat: String, lon: String)  {
        currentParam = ["appKey": Constants.appKey, "lat": lat, "lon": lon]
        print("makeParam success")
    }
    
    private func statusValid(statusCode: Int) -> Bool { (200..<300).contains(statusCode) }
    
    private func makeUrl(endPoint: Constants.endPoint) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.baseUrl
        components.path = endPoint.rawValue
        guard let params = currentParam else { return nil }
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        return components.url
    
        
    }
    
    private init() {}
    
}
