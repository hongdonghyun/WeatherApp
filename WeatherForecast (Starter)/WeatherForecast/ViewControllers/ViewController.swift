//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private let weatherTableView = WeatherTableView()
    private let imageView = BackgroundImageView(image: UIImage())
    private let blurView = BackgroundBlurView()
    
    private var locationManager = CLLocationManager()
    private var lastContentOffset: CGFloat = 0
    private var imageViewCenterConstraint: NSLayoutConstraint!
    private var currentWeather: CurrentWeather?
    private var shortTemp: [[String: String]] = []
    
    private var shortSky: [[String: String]] = []
    
    private var timeRelease: String = ""
    
    private var naviTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorizationStatus()
        setup()
        setupUI()
    }
}

// MARK: SetupUI
extension ViewController {
    func setup() {
        locationManager.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.register(CurrentWeatherCell.self, forCellReuseIdentifier: CurrentWeatherCell.identifier)
        weatherTableView.register(ShortTermWeatherCell.self, forCellReuseIdentifier: ShortTermWeatherCell.identifier)
        
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        view.addSubview(imageView)
        imageView.addSubview(blurView)
        view.addSubview(weatherTableView)
        
        [imageView, blurView, weatherTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        imageViewCenterConstraint = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        NSLayoutConstraint.activate([
            imageViewCenterConstraint,
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.5),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            weatherTableView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ViewController {
    func checkAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            fallthrough
        case .authorizedAlways:
            startUpdatingLocation()
        case .restricted, .denied: break
        @unknown default: break
        }
    }
    
    func getAddress(location: CLLocation) {
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "ko")
        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
            if let address: [CLPlacemark] = placemarks {
                self.navigationItem.title = address.last?.name
            }
        }
    }
    
    func startUpdatingLocation() {
        let status = CLLocationManager.authorizationStatus()
        guard status == .authorizedWhenInUse || status == .authorizedAlways else { return }
        guard CLLocationManager.locationServicesEnabled() else { return }
        locationManager.startUpdatingLocation()
        getAddress(location: locationManager.location!)
        RequestHelper.shared.makeParam(location: locationManager.location)
        //        DispatchQueue.global().async { [weak self] in
        RequestHelper.shared.request(method: .get, endPoint: .currentWeatherEndPoint) {
            if let jsonData = try? JSONDecoder().decode(CurrentWeather.self, from: $0) {
                self.currentWeather = jsonData
                
                DispatchQueue.main.async {
                    if let name = self.currentWeather?.weather.hourly.first?.sky.name {
                        if name.contains("맑음") {
                            self.imageView.image = UIImage(named: "sunny")
                        } else if name.contains("낙뢰") {
                            self.imageView.image = UIImage(named: "lightning")
                        } else if name.contains("구름") {
                            self.imageView.image = UIImage(named: "cloudy")
                        } else if name.contains("흐") || name.contains("비") {
                            self.imageView.image = UIImage(named: "rainy")
                        }
                    }
                    self.weatherTableView.reloadData()
                    print("currentWeather reload")
                }
            }
        }
        RequestHelper.shared.request(method: .get, endPoint: .shortTermforecast) {
            if let jsonData = try? JSONDecoder().decode(ShortTermWeatherModel.self, from: $0) {
                guard let timeRelease = jsonData.weather.forecast3Days.first?.timeRelease else { return }
                self.timeRelease = timeRelease
                if let _sky = jsonData.weather.forecast3Days.first?.fcst3Hour.sky {
                    let sky = _sky.filter{ $0.value != "" }.mapValues({ $0 })
                    let skySorted = sky.sorted { (first, second) -> Bool in
                        Int(first.key.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())! < Int(second.key.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())!
                        
                    }
                    skySorted.forEach {
                        if $0.0.contains("code") {
                            self.shortSky.append([$0.0: $0.1])
                        }
                    }
                }
                if let _temp = jsonData.weather.forecast3Days.first?.fcst3Hour.temperature {
                    let temp = _temp.filter{ $0.value != "" }.mapValues({ $0 })
                    let tempSorted = temp.sorted { (first, second) -> Bool in
                        Int(first.key.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())! < Int(second.key.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())!
                    }
                    tempSorted.forEach {
                        self.shortTemp.append([$0.0: $0.1])
                    }
                }
                DispatchQueue.main.async {
                    self.weatherTableView.reloadData()
                    print("shortTermforecast reload")
                }
            }
            
        }
        
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return view.frame.height - view.safeAreaInsets.top
        default:
            return 100
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        let blur = blurView.blurEffectView
        
        if 0 <= yPosition && yPosition < (scrollView.frame.maxY / 4) {
            imageViewCenterConstraint.constant = (yPosition / (scrollView.frame.maxY / 4) * 20).rounded(.up)
            blur.alpha = yPosition / (scrollView.frame.maxY / 2).rounded(.up)
            
        } else if 0 > yPosition  {
            blur.alpha = 0
            imageViewCenterConstraint.constant = 0
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        if currentWeather != nil { count = 1 }
        if !shortTemp.isEmpty { count = 2 }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard let count = currentWeather?.weather.hourly.count else { return 0 }
            return count
        default:
            return shortTemp.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard
                let currentWeather = currentWeather,
                let cell = tableView.dequeueReusableCell(withIdentifier: CurrentWeatherCell.identifier, for: indexPath) as? CurrentWeatherCell
                else { return UITableViewCell() }
            cell.config(weather: currentWeather)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ShortTermWeatherCell.identifier, for: indexPath) as? ShortTermWeatherCell
                else { return UITableViewCell() }
            cell.config(
                temp: shortTemp[indexPath.row],
                sky: shortSky[indexPath.row],
                time: timeRelease
            )
            
            return cell
        }
    }
    
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("인증됨")
        default:
            print("인증실패")
        }
    }
}
