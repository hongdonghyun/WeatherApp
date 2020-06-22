//
//  ViewController.swift
//  WeatherForecast
//
//  Created by hong3 on 2020/02/22.
//  Copyright © 2020 hong3. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    private var currentWeather: CurrentWeather?
    private var shortTemp: [[String: String]] = []
    private var shortSky: [[String: String]] = []
    
    private var locationManager = CLLocationManager()
    private var imageViewCenterConstraint: NSLayoutConstraint!
    private var timeRelease: String = ""
    private var latestUpdateDate = Date(timeIntervalSinceNow: -10)
    
    private let rootView = WeatherView()
    
    override func loadView() { view = rootView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Constants.appKey)
        checkAuthorizationStatus()
        setup()
    }
}

extension WeatherViewController {
    private func startUpdatingLocation() {
        let status = CLLocationManager.authorizationStatus()
        guard status == .authorizedWhenInUse || status == .authorizedAlways else { return }
        guard CLLocationManager.locationServicesEnabled() else { return }
        locationManager.startUpdatingLocation()
    }
    
    func checkAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .restricted, .denied: break
        @unknown default: break
        }
    }
    
    private func getData() {
        RequestHelper.shared.request(method: .get, endPoint: .currentWeatherEndPoint) { [weak self] in
            if let jsonData = try? CurrentWeather.decode(from: $0) {
                self?.currentWeather = jsonData
                DispatchQueue.main.async {
                    self?.changedBackgroundImage()
                    self?.rootView.weatherTableView.reloadData()
                }
                print("currentWeather reload")
                
            }
        }
        RequestHelper.shared.request(method: .get, endPoint: .shortTermforecast) { [weak self] in
            if let jsonData = try? ShortTermWeatherModel.decode(from: $0) {
                guard let timeRelease = jsonData.weather.forecast3Days.first?.timeRelease else { return }
                self?.timeRelease = timeRelease
                if let _sky = jsonData.weather.forecast3Days.first?.fcst3Hour.sky {
                    let skySorted = _sky.filter{ $0.value != "" }.mapValues({ $0 }).sorted {
                        $0.key.getStrInInt() < $1.key.getStrInInt()
                    }
                    skySorted.forEach {
                        if $0.0.contains("code") { self?.shortSky.append([$0.0: $0.1]) }
                    }
                }
                if let _temp = jsonData.weather.forecast3Days.first?.fcst3Hour.temperature {
                    let tempSorted = _temp.filter{ $0.value != "" }.mapValues({ $0 }).sorted {
                        $0.key.getStrInInt() < $1.key.getStrInInt()
                    }
                    tempSorted.forEach {
                        self?.shortTemp.append([$0.0: $0.1])
                    }
                }
                DispatchQueue.main.async {
                    self?.rootView.weatherTableView.reloadData()
                    print("shortTermforecast reload")
                }
            }
            
        }
    }
    
}

// MARK: - LocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        manager.stopUpdatingLocation()
        
        // 마지막요청후 2초가 지나야 작업실행
        let currentDate = Date()
        if abs(latestUpdateDate.timeIntervalSince(currentDate)) > 2 {
            changeTitle(location: location)
            RequestHelper.shared.makeParam(location: location)
            getData()
            latestUpdateDate = currentDate
        }
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return rootView.weatherTableView.frame.height - rootView.titleView.safeAreaInsets.top
        default:
            return 100
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        let blur = rootView.blurView
        
        if 0 <= yPosition && yPosition < (scrollView.frame.maxY / 4) {
            rootView.imageViewCenterConstraint.constant = (yPosition / (scrollView.frame.maxY / 4) * 20).rounded(.up)
            blur.alpha = yPosition / (scrollView.frame.maxY / 2).rounded(.up)
            
        } else if 0 > yPosition  {
            blur.alpha = 0
            rootView.imageViewCenterConstraint.constant = 0
        }
    }
}

extension WeatherViewController: UITableViewDataSource {
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

// MARK: ACTIONS
extension WeatherViewController {
    
    @objc func RefreshButtonAction(_ sender: UIButton) {
        startUpdatingLocation()
        let spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.duration = 0.5
        spinAnimation.toValue = CGFloat.pi * 2
        sender.layer.add(spinAnimation, forKey: "spinAnimation")
    }
    
    private func changeTitle(location: CLLocation) {
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: Constants.localeKo)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateType.currentDate.rawValue
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
            guard error == nil else { return print(error!.localizedDescription) }
            guard let place = placemarks?.first else { return }
            let locality = place.locality ?? ""
            let subLocality = place.subLocality ?? ""
            let throughfare = place.thoroughfare ?? ""
            let address = locality + " " + (!subLocality.isEmpty ? subLocality : throughfare)
            
            DispatchQueue.main.async { [weak self] in
                self?.updateTitleView(address: address, time: dateFormatter.string(from: Date()))
            }
        }
    }
    
    private func changedBackgroundImage() {
        if let name = self.currentWeather?.weather.hourly.first?.sky.name {
            if name.contains("맑음") {
                self.rootView.imageView.image = UIImage(named: WeatherImages.sunny.rawValue)
            } else if name.contains("낙뢰") {
                self.rootView.imageView.image = UIImage(named: WeatherImages.lightning.rawValue)
            } else if name.contains("구름") {
                self.rootView.imageView.image = UIImage(named: WeatherImages.cloudy.rawValue)
            } else if name.contains("흐") || name.contains("비") {
                self.rootView.imageView.image = UIImage(named: WeatherImages.rainy.rawValue)
            }
        }
    }
    
    private func setup() {
        locationManager.delegate = self
        rootView.weatherTableView.dataSource = self
        rootView.weatherTableView.delegate = self
        rootView.weatherTableView.register(CurrentWeatherCell.self, forCellReuseIdentifier: CurrentWeatherCell.identifier)
        rootView.weatherTableView.register(ShortTermWeatherCell.self, forCellReuseIdentifier: ShortTermWeatherCell.identifier)
        rootView.refreshButton.addTarget(self, action: #selector(RefreshButtonAction(_:)), for: .touchUpInside)
    }
    
    private func updateTitleView(address: String, time: String) {
        rootView.titleLabel.text = address
        rootView.titleTimeLabel.text = time
        
        rootView.titleLabel.alpha = 0
        rootView.titleTimeLabel.alpha = 0
        rootView.refreshButton.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.rootView.titleLabel.alpha = 1
            self.rootView.refreshButton.alpha = 1
            self.rootView.refreshButton.alpha = 1
        }
    }
}
