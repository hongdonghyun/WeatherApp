//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let weatherTableView = WeatherTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RequestHelper.shared.makeParam(lat: "37.5607756", lon: "127.0320914")
        RequestHelper.shared.request(method: .get, endPoint: .currentWeatherEndPoint) {
            print($0)
        }
    }
    
    
}

